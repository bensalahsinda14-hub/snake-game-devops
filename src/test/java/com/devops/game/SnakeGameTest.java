package com.devops.game;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class SnakeGameTest {
    
    @Test
    public void testGameInitialization() {
        SnakeGame game = new SnakeGame();
        assertNotNull(game.getSnake());
        assertEquals(3, game.getSnake().size());
        assertEquals(0, game.getScore());
        assertFalse(game.isGameOver());
    }
    
    @Test
    public void testSnakeMovement() {
        SnakeGame game = new SnakeGame();
        int initialSize = game.getSnake().size();
        game.move();
        assertEquals(initialSize, game.getSnake().size());
    }
    
    @Test
    public void testFoodExists() {
        SnakeGame game = new SnakeGame();
        assertNotNull(game.getFood());
    }
}
