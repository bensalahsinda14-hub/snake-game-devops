package com.devops.game;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class SnakeGame {
    private List<Position> snake;
    private Position food;
    private int score;
    private boolean gameOver;
    
    public static class Position {
        int x, y;
        public Position(int x, int y) {
            this.x = x;
            this.y = y;
        }
        public int getX() { return x; }
        public int getY() { return y; }
    }
    
    public SnakeGame() {
        snake = new ArrayList<>();
        snake.add(new Position(10, 10));
        snake.add(new Position(9, 10));
        snake.add(new Position(8, 10));
        score = 0;
        gameOver = false;
        food = new Position(15, 15);
    }
    
    public List<Position> getSnake() { return snake; }
    public Position getFood() { return food; }
    public int getScore() { return score; }
    public boolean isGameOver() { return gameOver; }
    
    public void move() {
        if (!gameOver) {
            Position head = snake.get(0);
            Position newHead = new Position(head.x + 1, head.y);
            snake.add(0, newHead);
            
            if (newHead.x == food.x && newHead.y == food.y) {
                score += 10;
                food = new Position(new Random().nextInt(20), new Random().nextInt(20));
            } else {
                snake.remove(snake.size() - 1);
            }
            
            if (newHead.x < 0 || newHead.x >= 20 || newHead.y < 0 || newHead.y >= 20) {
                gameOver = true;
            }
        }
    }
}
