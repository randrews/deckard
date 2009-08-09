class Deckard::Deck
  attr_accessor :cards

  def initialize spreadsheet_name, worksheet_name
    spreadsheet = Deckard.session.spreadsheets("title"=>spreadsheet_name)[0]
    raise ArgumentError.new("Invalid spreadsheet name: \"#{spreadsheet_name}\"") unless spreadsheet

    spreadsheet.worksheets.each do |w|
      @worksheet = w if w.title == worksheet_name
    end

    raise ArgumentError.new("Invalid worksheet name: \"#{worksheet_name}\" for spreadsheet \"#{spreadsheet_name}\"") unless @worksheet

    self.cards = parse_cards
  end

  def parse_cards
    cards = []
    current_card = nil
    (2..(@worksheet.num_rows)).each do |row_num|
      row_contents = get_row(row_num)
      next if is_blank? row_contents

      row_hash = hashify_row row_contents
      if is_card? row_contents
        cards << current_card if current_card
        current_card = Deckard::Card.new(row_hash)
      else
        raise RuntimeError.new("Invalid spreadsheet format; expected a card to start at row #{row_num}") unless current_card
        current_card << row_hash
      end
    end

    cards << current_card if current_card

    cards
  end

  def each row, &blk
    check_valid row

    (1..(@worksheet.num_cols)).each do |col|
      blk[@worksheet[row,col], col]
    end
  end

  def map row, &blk
    arr = []
    each(row){|val,col| arr << blk[val,col] }
    arr
  end

  def get_row row
    map(row){|val,col| val }
  end

  def header
    @header ||= get_row(1)
  end

  def hashify_row row_contents
    hash = {}
    row_contents.each_with_index do |cell, idx|
      hash[header[idx].downcase.to_sym] = cell unless cell.nil? or cell.empty?
    end
    hash
  end

  def is_card? row_contents
    !(row_contents[0].nil? || row_contents[0].empty?)
  end

  def is_blank? row_contents
    !(row_contents.any?)
  end

  def check_valid row
    raise ArgumentError.new("Invalid row #{row}") if row < 1 or row > @worksheet.num_rows
  end

  def to_s
    "<Deck: #{@worksheet.title} cards: #{cards.size}>"
  end

  def inspect ; to_s ; end
end
