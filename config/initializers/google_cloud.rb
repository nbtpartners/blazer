class GoogleCloud
  def initialize
    @bigquery ||= begin
      require "google/cloud/bigquery"
      Google::Cloud::Bigquery.new(
          project: YAML.load_file("./config.yml")['development']['big_query']['project'],
          keyfile: YAML.load_file("./config.yml")['development']['big_query']['keyfile']
      )
    end
    @storage = storage = Google::Cloud::Storage.new(
        project: YAML.load_file("./config.yml")['development']['big_query']['project'],
        keyfile: YAML.load_file("./config.yml")['development']['big_query']['keyfile']
    )
    @bucket = storage.bucket "cashslide_wheelhouse"
  end

  def storage
    @storage
  end

  def bucket
    @bucket
  end

  def bucket_link
    'gs://cashslide_wheelhouse/'
  end

  def extract_url(query, query_id) # 쿼리를 구글 storage 로 추출한다.
    date = Date.today.to_s
    timestamp = Time.now.to_i
    file_path = "#{bucket_link}#{date}/#{query_id}_#{timestamp}.csv"
    query_job = @bigquery.query_job query

    query_job.wait_until_done!

    if !query_job.failed?
      res= query_job.destination.extract_job file_path, format: "csv"
      full_link = res.destinations.first # 어레이로 반환함
      full_link.remove bucket_link
    else
      ''
    end

  end

  def download(remote_path)
    file = @bucket.file remote_path
    res = file.download "./tmp/#{remote_path.split('/').last}"
    return res
  end

end


