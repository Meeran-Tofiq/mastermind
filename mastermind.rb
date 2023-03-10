class Player
    def initialize(board, code_breaker)
        @board = board
        @code_breaker = code_breaker
    end
end

class Board
    attr_accessor :code, :board, :guesses

    def initialize
        @code = Array.new(4) {0}
        @board = Array.new(10) {Array.new(4) {0}}            
        @guesses = Array.new(10) {Array.new(4)}
    end

    def display_board(win)
        if win
            p code
        else
            p Array.new(4) {"Ø"}
        end

        board.each_with_index do |row, i|
            print row
            print "     "
            p guesses[i]
        end
    end
end

board = Board.new
board.display_board(true)