# frozen_string_literal: true
# vendors channel
class VendorsChannel < ApplicationCable::Channel

  def subscribed
    stream_from "vendors_channel_#{params[:vendor_id]}"
  end

  def unsubscribed ;end
end
