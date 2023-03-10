class Player
    attr_reader :code_breaker, :board
    def initialize(board, code_breaker)
        @board = board
        @code_breaker = code_breaker
    end

    def make_code(code)
        if code_breaker
            return
        end

        board.code = code
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
player = Player.new(board, false)

player.make_code([1,2,3,4])
board.display_board(true)