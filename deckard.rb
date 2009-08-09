require 'rubygems'
require 'google_spreadsheet'
require 'yaml'

$DIR = File.dirname(__FILE__)

module Deckard
  def self.config
    @config ||= YAML.load(File.open(File.join($DIR,'config.yml')))
  end

  def self.spreadsheets
    @spreadsheets ||= session.spreadsheets.map{|s| s.title}
  end

  def self.session
    @session ||= GoogleSpreadsheet.login(config['email'],config['password'])
  end
end

%w{card.rb deck.rb}.each do |file|
  path = File.join($DIR,file)
  load(path) if File.exists? path
end
