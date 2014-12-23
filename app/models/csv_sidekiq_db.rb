require 'csv'

class CsvSidekiqDb
  include Wisper::Publisher

  attr_reader :line_saver

  def initialize(line_saver = nil)
    @line_saver = line_saver
  end

  def convert_save(target_model, csv_file, &block)
    broadcast(:before_all, csv_file)
    dest = Rails.root.join("tmp/#{Time.now.to_i}_#{Process.pid}").to_s

    FileUtils.cp(csv_file.path, dest)

    CsvSidekiqWorker.perform_async(dest, target_model, line_saver)

    broadcast(:after_all, csv_file)
  end
end
