module AdminHelper
  def get_bread_crumb(url)
    begin
      breadcrumb = ''
      sofar = '/admin/'
      elements = url.split('/')[2..-1]
      elements.each_with_index do |element, i|
        sofar += element + '/'
        if i%2 == 1
          begin
            breadcrumb += "<a href='#{sofar}'>"  + eval("#{elements[i - 1].singularize.camelize}.find(#{element}).name").to_s + '</a>'
          rescue
            breadcrumb += element
          end
        elsif element != "edit"
          breadcrumb += "<a href='#{sofar}'>#{element.pluralize.camelize}</a>"
        else
          breadcrumb += element
        end
        breadcrumb += ' -> ' if i != elements.size - 1
      end
      breadcrumb
    rescue
      'Not available'
    end
  end
end
