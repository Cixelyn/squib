require 'spec_helper'
require 'squib'
require 'pp'

describe "Squib samples" do
  let(:samples_dir) { "#{File.expand_path(File.dirname(__FILE__))}/../../samples/" }

  around(:each) do |example|
    Dir.chdir(samples_dir) do
      example.run
    end
  end

  it 'should execute with no errors' do
    allow(ProgressBar).to receive(:create).and_return(Squib::DoNothing.new)
    Dir["#{samples_dir}/**/*.rb"].each do |sample|
      load sample
    end
  end

  # This test could use some explanation
  # Much of the development of Squib has been sample-driven. Every time I want
  # new syntax or feature, I write a sample, get it working, and then write
  # tests for boundary cases in the unit tests.
  #
  # This makes documentation much easier and example-driven.
  # ...but I want to use those samples for regression & integration tests too.
  #
  # The above test is a good smoke test, but it just looks for exceptions.
  # What this set of tests do is run the samples again, but mocking out Cairo,
  # Pango, RSVG, and any other dependencies. We log those API calls and store
  # them in a super-verbose string. We compare our runs against what happened
  # before.
  #
  # Thus, if we ever change anything that results in a ANY change to our
  # regression logs, then these tests will fail. If it's SURPRISING, then we
  # caught an integration bug. If it's not, just update and overwrite the logs.
  #
  # So it's understood that you should have to periodically enable the
  # overwrite_sample method below to store the new regression log. Just make
  # sure you inspect the change and make sure it makes sense with the change
  # you made to the samples or Squib.
  %w( hello_world.rb
      autoscale_font.rb
      layouts.rb
      save_pdf.rb
      custom_config.rb
      load_images.rb
      basic.rb
      cairo_access.rb
      draw_shapes.rb
      text_options.rb
      colors.rb
      excel.rb
      portrait-landscape.rb
      tgc_proofs.rb
      ranges.rb
      units.rb
  ).each do |sample|
    it "has not changed for #{sample}" do
      log = StringIO.new
      mock_cairo(log)
      load sample
      # overwrite_sample(sample, log) # Use TEMPORARILY once happy with the new sample log
      test_file_str = File.open(sample_regression_file(sample))
                          .read.force_encoding("UTF-8")
      expect(log.string).to eq(test_file_str)
    end
  end

end