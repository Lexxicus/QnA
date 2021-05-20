require 'rails_helper'

RSpec.describe NotificationJob, type: :job do
  let(:answer)  { create(:answer) }
  let(:service) { double('NotificationService') }

  before do
    allow(NotificationService).to receive(:new).and_return(service)
  end

  it 'calls NotificationService#send_notification' do
    expect(service).to receive(:send_notification).with(answer)
    NotificationJob.perform_now(answer)
  end
end
