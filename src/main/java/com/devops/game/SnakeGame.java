package com.devops.game;

import java.util.*;

public class SnakeGame {
    private int width;
    private int height;
    private int score;
    private int level;
    private String difficulty;
    
    public static class Position {
        public int x;
        public int y;
        
        public Position(int x, int y) {
            this.x = x;
            this.y = y;
        }
        
        @Override
        public boolean equals(Object obj) {
            if (this == obj) return true;
            if (obj == null || getClass() != obj.getClass()) return false;
            Position position = (Position) obj;
            return x == position.x && y == position.y;
        }
        
        @Override
        public int hashCode() {
            return Objects.hash(x, y);
        }
    }
    
    public SnakeGame(int width, int height) {
        this.width = width;
        this.height = height;
        this.score = 0;
        this.level = 1;
        this.difficulty = "medium";
    }
    
    public int getWidth() {
        return width;
    }
    
    public int getHeight() {
        return height;
    }
    
    public int getScore() {
        return score;
    }
    
    public void setScore(int score) {
        this.score = score;
    }
    
    public int getLevel() {
        return level;
    }
    
    public void setLevel(int level) {
        this.level = level;
    }
    
    public String getDifficulty() {
        return difficulty;
    }
    
    public void setDifficulty(String difficulty) {
        this.difficulty = difficulty;
    }
    
    public int getSpeedByDifficulty() {
        switch(difficulty) {
            case "easy": return 200;
            case "medium": return 150;
            case "hard": return 100;
            case "expert": return 60;
            default: return 150;
        }
    }
    
    public int calculateLevelSpeed(int baseSpeed) {
        return Math.max(50, baseSpeed - (level * 10));
    }
}
