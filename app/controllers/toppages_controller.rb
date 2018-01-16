class ToppagesController < ApplicationController
  require "google/cloud/language"
  
  def index
  
  end

  def syntax
  
  end

  def show
    # [START syntax_from_text]
    # text_content = "Text to analyze syntax of"
    text_content = params[:content]
    
    # 検索クエリのDBへの保存
    @data = Datum.new(contents: text_content)
    @data.save
    
    
    language = Google::Cloud::Language.new
    response = language.analyze_syntax content: text_content, type: :PLAIN_TEXT
    tokens = response.tokens
    
    
    @keywords = ''
  
    tokens.each do |token|
      # @keywords = token.text.content
        if token.part_of_speech.tag == :NOUN
          @keywords += token.text.content + " "
        end
      
        if @keywords != ""
          
        else
          if token.part_of_speech.tag == :VERB
            @keywords += token.text.content + " "
          end
        end
    end      
    # [END syntax_from_text]  
    #binding.pry
    
    agent = Mechanize.new
    @page = agent.get('http://elaws.e-gov.go.jp/search/elawsSearch/elaws_search/lsg0100')

    form = @page.form_with(name: 'form_search_yourei')
    form.action = 'http://elaws.e-gov.go.jp/search/elawsSearch/elaws_search/lsg0100/search'
    form.field_with(name: 'lawWordSearchEGovCondBean.searchWord').value = @keywords
    form.field_with(name: 'searchType').value = 1
    form.field_with(name: 'lawWordSearchEGovCondBean.searchPattern').value = 1
    form.field_with(name: 'lawWordSearchEGovCondBean.searchTargetKbn').value = 3
    form.field_with(name: 'lawWordSearchEGovCondBean.searchUnitKbn').value = 1
    form.field_with(name: 'lawWordSearchEGovCondBean.resultKbn').value = 4
    @rt_page = agent.submit(form)
    
    @rtd = @rt_page.search('//table[@class="table table-striped table-condensed table-bordered"]//tr')
    
  end
  
  def article
    
    lawNum = params[:lawNum]
    article = params[:article]
    
    url = "http://elaws.e-gov.go.jp/api/1/articles;lawNum=#{lawNum};article=#{article}"
  
    agent = Mechanize.new
    @page = agent.get(url)
    @doc = @page.xml.children.children.children.children.inner_text
     
    @rtd = Nokogiri::HTML.parse(@doc)
    @atc = @rtd.children.children.children.children.children.children.children.children
    
  end
end
