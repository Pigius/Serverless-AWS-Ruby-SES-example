# frozen_string_literal: true

require 'aws-sdk-ses'
require 'logger'

class SesAdapter

  def initialize(reminder_title)
    @ses_client = Aws::SES::Client.new
    @reminder_title = reminder_title
  end

  def send_email
    ses_client.send_email(mail_data)
    logger.info('Email was sent')
  rescue Aws::SES::Errors::ServiceError => error
    logger.error(error)
  end

  private

  attr_reader :ses_client, :reminder_title

  def mail_data
    sender = ENV['SENDER']
    recipient = ENV['RECIPIENT']
    subject = "Your reminder about #{reminder_title}"
    textbody = "This email was sent with Amazon SES triggers via AWS Step Functions to reminder you about #{reminder_title}"

    encoding = 'UTF-8'
    htmlbody =
      "<h1>Your reminder about #{reminder_title}</h1>"\
      "<p>This is your reminder about the #{reminder_title} which you set up some time ago.</p>"\

    {
      destination: {
        to_addresses: [
          recipient
        ]
      },
      message: {
        body: {
          html: {
            charset: encoding,
            data: htmlbody
          },
          text: {
            charset: encoding,
            data: textbody
          }
        },
        subject: {
          charset: encoding,
          data: subject
        }
      },
      source: sender
    }
  end

  def logger
    @logger ||= Logger.new($stdout)
  end
end
