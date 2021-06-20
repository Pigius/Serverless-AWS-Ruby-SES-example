# frozen_string_literal: true

require_relative '../adapters/ses_adapter'

class SendEmailService

  def initialize(reminder_title)
    @reminder_title = reminder_title
  end

  def call
    send(reminder_title)
  end

  private

  attr_reader :reminder_title

  def send(reminder_title)
    SesAdapter.new(reminder_title).send_email
  end
end
