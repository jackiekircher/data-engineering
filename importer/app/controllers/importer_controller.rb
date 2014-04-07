class ImporterController < ApplicationController

  def input_data

  end

  def import_data
    if params[:csv_file].blank?
      render :input_data and return
    end

    @importer = CSVImporter.new(params[:csv_file])
    @importer.persist
  end
end
