module Api
  module V1
    class OfxController < ApplicationController
      def create
        ofx_file = params[:ofx_file]
        binding.b

        if ofx_file.include?('.ofx')
          result = OfxParserService.new(File.open(ofx_file)).call
          render json: { message: 'OFX file processed successfully', result: }, status: :ok
        else
          render json: { error: 'Invalid file type. Please upload an OFX file.' },
                 status: :unprocessable_content
        end
      end
    end
  end
end
