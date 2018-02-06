class CloudService  #sigleton 모듈이 필요할지는 나중에 알아보자
  def initialize(name)
    if name == 'google'
      @cloud = GoogleCloud.new
    elsif name == 'amazon'
      #TODO 추후 구현
    end
  end

  def cloud
    @cloud
  end
end
