class GoogleCloudService  #sigleton 모듈이 필요할지는 나중에 알아보자
  def initialize
    require "google/cloud/bigquery"
    require "google/cloud/storage"

    @bigquery = Google::Cloud::Bigquery.new(
        project: YAML.load_file("./config.yml")['development']['big_query']['project'],
        keyfile: YAML.load_file("./config.yml")['development']['big_query']['keyfile']
    )

    @storage = Google::Cloud::Storage.new(
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

  def bigquery
    @bigquery
  end

  def query(sql)
    bigquery.query(sql)
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
      res = query_job.destination.extract_job file_path, format: "csv"
      res.wait_until_done!
      full_link = res.destinations.first # 어레이로 반환함

      remote_file_link = full_link.remove bucket_link

      remote_file = @bucket.file remote_file_link
      down_file = remote_file.download "./tmp/#{remote_file_link.split('/').last}"

      return down_file
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


