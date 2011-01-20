module Admin::MessagesHelper
  def parse_email_list(list)
    return [] if list.nil?
    result = YAML.load(@message.emails_sent)
    
    if result.instance_of?(String)
      result.split(/,\s+/)
    else
      result
    end
  end
end