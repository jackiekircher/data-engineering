require 'spec_helper'

describe ImporterController do

  describe "get #input_data" do

    it "loads succesffuly" do
      get :input_data
      expect(response).to be_success
    end
  end

  describe "post #import_data" do

    it "renders the input_data form if there's no file" do
      post :import_data
      expect(response).to render_template("input_data")
    end

    it "renders the import_data total if the file upload
        is successful" do
      importer = double("csv_importer", persist: true)
      allow(CSVImporter).to receive(:new) { importer }

      post :import_data, csv_file: StringIO.new("foo")
      expect(response).to render_template("import_data")
    end
  end
end
