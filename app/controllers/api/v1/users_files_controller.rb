class Api::V1::UsersFilesController < Api::V1::ApplicationController
    include Api::V1::ApplicationHelper
    rescue_from Exception, with: :server_error

    def update

        # Handle the (only) case of issued government ID
        if params.has_key?(:file) && params.has_key?(:file_type)
            if params[:file_type].downcase == 'government_id'
                if params[:file].size > 3145728 || !['.jpg', '.jpeg', '.png', '.pdf'].include?(File.extname(params[:file]).downcase)
                    render_error(400, 40003, 'Invalid input file')
                else 
                    # Save the file as tmp
                    current_user.tmp_gov_id.attach(params[:file])
                    render_response(200, :gov_id => url_for(current_user.tmp_gov_id))
                end
            else render_error(400, 40002, 'Unsupported file type') end
        else 
            render_error(400, 40001, 'Missing parameter(s)') 
        end
  
    end

end
