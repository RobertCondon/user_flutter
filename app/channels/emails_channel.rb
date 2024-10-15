class EmailsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'emails'
  end
end
