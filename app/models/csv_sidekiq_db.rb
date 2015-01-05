require 'csv'

class CsvSidekiqDb
  include Wisper::Publisher

  attr_reader :line_saver

  def initialize(line_saver = nil)
    @line_saver = line_saver
  end

  def convert_save(target_model, csv_file, &block)
    broadcast(:before_all, csv_file)

    file = TmpFile.create(file: csv_file)

    CsvSidekiqWorker.perform_async(file.id, target_model, line_saver)

    broadcast(:after_all, csv_file)
  end
end
