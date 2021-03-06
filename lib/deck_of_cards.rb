class DeckOfCards
  JOKER_A = "a"
  JOKER_B = "b"

  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def obtain_keystream(size)
    keystream = ''
    size.times do
      keystream << obtain_next_letter!
    end
    keystream
  end

  def move_joker_A_down!
    move_card_down(JOKER_A, 1)
  end

  def move_joker_B_down!
    move_card_down(JOKER_B, 2)
  end

  def perform_triple_cut!
    l, r = [cards.index(JOKER_A), cards.index(JOKER_B)].sort

    left   = l > 0 ? cards[0..l - 1] : []
    middle = cards[l..r]
    right  = cards[(r + 1)..(cards.size - 1)]

    @cards = right.concat(middle).concat(left)
  end

  def perform_count_cut!
    count = cards.last

    return cards if card_is_joker?(count)

    cut = cards[0..count-1]
    remainder = cards[count..cards.size-2]

    @cards = remainder.concat(cut).concat([count])
  end

  def obtain_next_letter!
    card = obtain_next_valid_card!

    numbers_to_letters([card])
  end

  def obtain_next_valid_card!
    move_joker_A_down!
    move_joker_B_down!
    perform_triple_cut!
    perform_count_cut!

    card = obtain_next_card

    if card_is_joker?(card)
      obtain_next_valid_card!
    else
      card
    end
  end

  def obtain_next_card
    position = value_of_card(cards[0])
    cards[position]
  end

  def value_of_card(card)
    card_is_joker?(card) ? 53 : card
  end

  def letters_to_numbers(letters)
    letters.map { |letter| letter.ord - 'A'.ord + 1 }
  end

  def numbers_to_letters(numbers)
    numbers.map { |number| wrap_and_convert_to_letter(number) }.join
  end

  def wrap_and_convert_to_letter(n)
    convert_to_letter(wrap_after_26(n))
  end

  def convert_to_letter(number)
    (number + 'A'.ord - 1).chr
  end

  def wrap_after_26(number)
    if number > 26
      number - 26
    else
      number
    end
  end

  private

  def card_is_joker?(card)
    [JOKER_A, JOKER_B].include?(card)
  end

  def move_card_down(card, count)
    current_position = cards.index(card)
    new_position = current_position + count

    if new_position >= cards.size
      new_position -= cards.size - 1
    end

    cards.delete_at(current_position)
    cards.insert(new_position, card)
  end
end