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
