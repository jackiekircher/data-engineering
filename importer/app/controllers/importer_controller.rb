class ImporterController < ApplicationController

  def input_data
    @errors = []
  end

  def import_data
    if params[:csv_file].blank?
      @errors = ["You must submit a file to upload"]
      render :input_data and return
    end

    begin
      @importer = CSVImporter.new(params[:csv_file])
      @importer.persist

    rescue ActiveRecord::RecordInvalid, IOError => error
      @errors << error
    end
  end
end
