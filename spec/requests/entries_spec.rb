require 'rails_helper'

RSpec.describe '/entries', type: :request do
  describe 'index' do
    let!(:entry1) { create(:entry, temperature: 13.5, humidity: 24.5) }
    let!(:entry2) { create(:entry, temperature: 14.5, humidity: 25.5) }
    let(:expected_response) do
      {
        entries: [entry1.as_json, entry2.as_json]
      }.stringify_keys
    end

    it 'returns entries' do
      get entries_path
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json_response).to eq(expected_response)
    end

    context 'pagination' do
      before do
        30.times do
          create(:entry)
        end
      end

      it 'paginates entries' do
        get entries_path
        json_response = JSON.parse(response.body)

        expect(json_response['entries'].length).to eq(25)
      end

      it 'can query page' do
        get entries_path, params: { page: 2 }
        json_response = JSON.parse(response.body)

        expect(json_response['entries'].length).to eq(7)
      end
    end
  end

  describe 'create' do
    let(:params) do
      {
        entry: {
          temperature: temperature,
          humidity: humidity
        }
      }
    end

    context 'valid' do
      let(:temperature) { 10.6 }
      let(:humidity) { 10.3 }
      let(:entry) { Entry.last }

      it 'creates entry' do
        post entries_path, params: params
        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:created)
        expect(entry.temperature).to eq(temperature)
        expect(entry.humidity).to eq(humidity)
        expect(json_response).to eq(entry.as_json)
      end
    end

    context 'invalid' do
      let(:temperature) { nil }
      let(:humidity) { 10.3 }
      let(:errors) { ['Temperature can\'t be blank'] }

      it 'returns errors' do
        post entries_path, params: params
        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to eq(errors)
      end
    end
  end
end
