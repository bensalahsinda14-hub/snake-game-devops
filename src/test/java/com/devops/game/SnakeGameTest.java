package com.devops.game;

import org.junit.Test;
import static org.junit.Assert.*;

public class SnakeGameTest {

    @Test
    public void testGameInitialization() {
        SnakeGame game = new SnakeGame(20, 20);
        assertNotNull(game);
        assertEquals(20, game.getWidth());
        assertEquals(20, game.getHeight());
        assertEquals(0, game.getScore());
        assertEquals(1, game.getLevel());
    }

    @Test
    public void testScoreUpdate() {
        SnakeGame game = new SnakeGame(20, 20);
        game.setScore(50);
        assertEquals(50, game.getScore());
    }

    @Test
    public void testLevelUpdate() {
        SnakeGame game = new SnakeGame(20, 20);
        game.setLevel(3);
        assertEquals(3, game.getLevel());
    }

    @Test
    public void testDifficultySpeed() {
        SnakeGame game = new SnakeGame(20, 20);
        
        game.setDifficulty("easy");
        assertEquals(200, game.getSpeedByDifficulty());
        
        game.setDifficulty("medium");
        assertEquals(150, game.getSpeedByDifficulty());
        
        game.setDifficulty("hard");
        assertEquals(100, game.getSpeedByDifficulty());
        
        game.setDifficulty("expert");
        assertEquals(60, game.getSpeedByDifficulty());
    }

    @Test
    public void testLevelSpeedCalculation() {
        SnakeGame game = new SnakeGame(20, 20);
        
        // Level 1
        game.setLevel(1);
        assertEquals(140, game.calculateLevelSpeed(150));
        
        // Level 5
        game.setLevel(5);
        assertEquals(100, game.calculateLevelSpeed(150));
        
        // Should not go below 50ms
        game.setLevel(20);
        assertEquals(50, game.calculateLevelSpeed(150));
    }

    @Test
    public void testPositionEquality() {
        SnakeGame.Position pos1 = new SnakeGame.Position(5, 10);
        SnakeGame.Position pos2 = new SnakeGame.Position(5, 10);
        SnakeGame.Position pos3 = new SnakeGame.Position(3, 8);
        
        assertEquals(pos1, pos2);
        assertNotEquals(pos1, pos3);
    }

    @Test
    public void testPositionHashCode() {
        SnakeGame.Position pos1 = new SnakeGame.Position(5, 10);
        SnakeGame.Position pos2 = new SnakeGame.Position(5, 10);
        
        assertEquals(pos1.hashCode(), pos2.hashCode());
    }
}
