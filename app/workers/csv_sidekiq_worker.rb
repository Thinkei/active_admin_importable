class CsvSidekiqWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(csv_path, target_model, line_saver)
    CSV.foreach(csv_path, headers: true, header_converters: :symbol) do |row|
      data = row.to_hash

      if data.present?
        line_saver.constantize.new(target_model, data).save
      end
    end
  end
end
