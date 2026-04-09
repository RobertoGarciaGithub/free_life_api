class OfxController < ApplicationController
  def create
    ofx_file = params[:ofx_file]

    if ofx_file.present?
      begin
        ofx_data = OfxParser::OfxParser.parse(ofx_file.path)
        render json: ofx_data, status: :ok
      rescue StandardError => e
        render json: { error: "Failed to parse OFX file: #{e.message}" },
               status: :unprocessable_content
      end
    else
      render json: { error: 'No OFX file provided' }, status: :bad_request
    end
  end
end
