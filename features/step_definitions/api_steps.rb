require 'json'
require 'rack/test'
require 'rspec/expectations' 
require 'rspec/matchers'

module ApiFeature
  include Rack::Test::Methods
  include RSpec::Matchers
  
  def app
    Rails.application
  end
  
  def last_response_json
    JSON.parse(last_response.body) rescue {} 
  end
  
  def set_context(key, value)
    @context ||= {}
    @context[key] = value
  end

  def get_context(key)
    @context ||= {}
    @context[key]
  end
end

World(ApiFeature)

# ----------------------------------------------------
#               GHERKIN STEP DEFINITIONS (Finalized)
# ----------------------------------------------------

# SETUP (GIVEN) ADIMLARI

Given('a user named {string} exists') do |user_name|
  @user = User.find_or_create_by!(forename: user_name) do |u|
    u.credit_balance = 50 
    u.role = 'user' 
  end
  set_context(:current_user, @user)
end

Given("the user's initial credit balance is {int}") do |balance|
  @user = get_context(:current_user)
  @user.update!(credit_balance: balance.to_i)
end

Given(/^the scale creation cost is (\d+) credits$/) do |cost|
  set_context(:scale_cost, cost.to_i)
end

# YENİ: Survey ve Response maliyetlerini tanımlar
Given(/^the survey creation cost is (\d+) credits$/) do |cost|
  set_context(:survey_cost, cost.to_i)
end

Given(/^the data collection cost is (\d+) credits$/) do |cost|
  set_context(:response_cost, cost.to_i)
end

# Ölçek oluşturma adımı (Survey senaryoları için ön koşul)
Given('a scale named {string} under the {string} exists') do |scale_title, user_name|
  @user = User.find_by!(forename: user_name)
  set_context(:current_user, @user)
  
  scale = Scale.create!(
    title: scale_title, 
    user: @user, 
    version: 1, 
    unique_scale_id: "SCALE_#{Time.now.to_i}_#{scale_title.gsub(/\s+/, '')}"
  )
  set_context(:current_scale, scale)
end

# Given a survey named "Survey X" exists under the scale "Scale Y"
Given('a survey named {string} exists under the scale {string}') do |survey_title, scale_title|
  scale = Scale.find_by!(title: scale_title)
  @user = scale.user # Kullanıcıyı güncel bağlama alıyoruz
  
  Survey.create!(
    title: survey_title, 
    scale: scale, 
    status: 'Active', 
    distribution_mode: 'public'
  )
end
# EYLEM (WHEN) ADIMLARI

# Ölçek oluşturma (Başarılı/Başarısız senaryoları için)
When('{string} attempts to create a scale named {string}') do |user_name, scale_title|
  @user = User.find_by!(forename: user_name)
  set_context(:current_user, @user)
  
  post_body = {
    scale: { 
      title: scale_title,
      user_id: @user.id,
      unique_scale_id: "SCALE_#{Time.now.to_i}_#{rand(1000)}" 
    }
  }
  post '/api/v1/scales', post_body.to_json, { 'CONTENT_TYPE' => 'application/json' }
end

When('{string} attempts to create a scale') do |user_name|
  @user = User.find_by!(forename: user_name)
  set_context(:current_user, @user)

  post_body = { 
    scale: { 
      title: "Unnamed Test Scale", 
      user_id: @user.id,
      unique_scale_id: "SCALE_POOR_#{Time.now.to_i}" 
    } 
  }
  post '/api/v1/scales', post_body.to_json, { 'CONTENT_TYPE' => 'application/json' }
end

# Yeni: Anket oluşturma adımı (Kredi düşüşünü test eder)
When(/^"([^"]*)" creates a survey under the "([^"]*)" scale$/) do |user_name, scale_title|
  @user = User.find_by!(forename: user_name)
  set_context(:current_user, @user)
  scale = Scale.find_by!(title: scale_title)
  set_context(:current_scale, scale)
  
  post_body = { survey: { title: "Auto Survey", distribution_mode: 'public' } }
  # Rota: /api/v1/scales/:scale_id/surveys
  post "/api/v1/scales/#{scale.id}/surveys", post_body.to_json, { 'CONTENT_TYPE' => 'application/json' }
end

# Yeni: Yanıt gönderme adımı (Veri toplama maliyetini test eder)
When(/^a response is submitted for the "([^"]*)" survey$/) do |survey_title|
  # Anketin başlığının "Auto Survey" olduğunu varsayıyoruz
  survey = Survey.find_by!(title: "Auto Survey") 
  
  response_body = {
    response: {
      participant_id: "PID-#{Time.now.to_i}",
      raw_data: { q1: 5, q2: 3 }
    }
  }
  # Rota: /api/v1/surveys/:survey_id/responses
  post "/api/v1/surveys/#{survey.id}/responses", response_body.to_json, { 'CONTENT_TYPE' => 'application/json' }
end


# DOĞRULAMA (THEN) ADIMLARI

# HTTP yanıt kodları için tek, birleşik bir adım tanımı (Ambiguous hatasını giderir)
Then(/^the HTTP response code should be (\d+) \((?:Created|Accepted|Payment Required)\)$/) do |expected_code|
  expect(last_response.status).to eq(expected_code.to_i),
    "Expected code #{expected_code} but got #{last_response.status}. Response: #{last_response.body}"
end


Then(/"([^"]*)"'s new credit balance should be (\d+)$/) do |user_name, expected_balance|
  @user = get_context(:current_user)
  @user.reload
  expect(@user.credit_balance).to eq(expected_balance.to_i)
end

Then(/"([^"]*)"'s credit balance should remain unchanged \((\d+)\)$/) do |user_name, expected_balance|
  @user = get_context(:current_user)
  @user.reload
  expect(@user.credit_balance).to eq(expected_balance.to_i)
end

Then('a Credit Transaction record of {string} should be created in the system') do |activity_type|
  transaction = CreditTransaction.last
  @user = get_context(:current_user)
  
  # Maliyeti aktivite tipine göre al (Senaryo 2'den gelen mantık)
  cost = case activity_type
         when 'ScaleDevelopment' then get_context(:scale_cost).to_i
         when 'SurveyCreation' then get_context(:survey_cost).to_i
         when 'DataCollection' then get_context(:response_cost).to_i
         else 1
         end
         
  expect(transaction.user_id).to eq(@user.id)
  expect(transaction.activity_type).to eq(activity_type)
  expect(transaction.cost.abs).to eq(cost) 
end

Then('no new Credit Transaction record should be created in the system') do
  last_transaction = CreditTransaction.last
  if last_transaction
    expect(last_transaction.user_id).not_to eq(get_context(:current_user).id), 
      "Kredi işlemi oluşmamalıydı, ancak son işlem mevcut kullanıcıya aittir."
  end
end