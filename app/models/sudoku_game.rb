class SudokuGame < ApplicationRecord
  enum :status, { in_progress: "in_progress", completed: "completed" }

  def self.create_new_game
    win_board = generate_valid_sudoku_solution
    initial_board = generate_initial_board(win_board)
    user_board = Array.new(9) { Array.new(9, nil) }

    initial_board.each_with_index do |row, row_index|
      row.each_with_index do |value, col_index|
        user_board[row_index][col_index] = value
      end
    end

    SudokuGame.create(
      win_board: win_board,
      initial_board: initial_board,
      user_board: user_board,
      status: :in_progress
    )
  end

  def self.generate_valid_sudoku_solution
    board = Array.new(9) { Array.new(9, nil) }
    fill_board(board)
    board
  end

  def self.fill_board(board)
    (0..8).each do |row|
      (0..8).each do |col|
        next if board[row][col]

        available_numbers = (1..9).to_a - row_values(board, row) - column_values(board, col) - subgrid_values(board, row, col)
        available_numbers.shuffle.each do |num|
          board[row][col] = num
          return true if fill_board(board)
          board[row][col] = nil
        end
        return false
      end
    end
    true
  end

  def self.generate_initial_board(win_board)
    initial_board = Array.new(9) { Array.new(9, nil) }
    2.times do
      row, col = rand(0..8), rand(0..8)
      initial_board[row][col] = win_board[row][col]
    end
    initial_board
  end

  def self.row_values(board, row)
    board[row].compact
  end

  def self.column_values(board, col)
    board.transpose[col].compact
  end

  def self.subgrid_values(board, row, col)
    subgrid_row = (row / 3) * 3
    subgrid_col = (col / 3) * 3
    subgrid = []
    (subgrid_row..subgrid_row + 2).each do |r|
      (subgrid_col..subgrid_col + 2).each do |c|
        subgrid << board[r][c] unless board[r][c].nil?
      end
    end
    subgrid
  end
end
