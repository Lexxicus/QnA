# frozen_string_literal: true

shared_examples_for 'API Listable' do
  it 'returns all public fields' do
    fields_list.each do |attr|
      expect(object_response[attr]).to eq object.send(attr).as_json
    end
  end
end

shared_examples_for 'Request successful' do
  it 'return 2xx status' do
    expect(response).to be_successful
  end
end
