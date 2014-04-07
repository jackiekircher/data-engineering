require 'spec_helper'

describe "importing data" do

  it "displays the total transaction amount when a csv is imported" do

    visit input_url
    attach_file('csv_file', File.join(Rails.root,
                                      'spec', 'data',
                                      'example_input.tab'))
    click_on 'import data'

    expect(page).to have_content('$95.00')
  end
end
