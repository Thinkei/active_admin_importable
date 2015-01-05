class CsvSidekiqWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(file, target_model, line_saver)
    csv = TmpFile.find(file)

    CSV.parse(csv.file.read, headers: true, header_converters: :symbol) do |row|
      data = row.to_hash

      if data.present?
        line_saver.constantize.new(target_model, data).save
      end
    end

    csv.destroy
  end
end
