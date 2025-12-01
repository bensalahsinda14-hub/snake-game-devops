<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pro Snake Game</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            max-width: 800px;
            width: 100%;
        }

        .header {
            text-align: center;
            margin-bottom: 20px;
        }

        .header h1 {
            color: #667eea;
            font-size: 2.5em;
            margin-bottom: 10px;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
        }

        .stats {
            display: flex;
            justify-content: space-around;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 15px;
        }

        .stat-box {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 25px;
            border-radius: 10px;
            min-width: 120px;
            text-align: center;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
            transition: transform 0.3s ease;
        }

        .stat-box:hover {
            transform: translateY(-3px);
        }

        .stat-label {
            font-size: 0.9em;
            opacity: 0.9;
            margin-bottom: 5px;
        }

        .stat-value {
            font-size: 1.8em;
            font-weight: bold;
        }

        .game-area {
            display: flex;
            justify-content: center;
            margin-bottom: 20px;
        }

        #gameCanvas {
            border: 4px solid #667eea;
            border-radius: 10px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.2);
            background: #f8f9fa;
        }

        .controls {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 1em;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 600;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }

        .settings-panel {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            border: 2px solid #e9ecef;
        }

        .setting-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            flex-wrap: wrap;
            gap: 10px;
        }

        .setting-row:last-child {
            margin-bottom: 0;
        }

        .setting-label {
            font-weight: 600;
            color: #495057;
        }

        select {
            padding: 8px 16px;
            border-radius: 6px;
            border: 2px solid #dee2e6;
            font-size: 1em;
            background: white;
            cursor: pointer;
            transition: border-color 0.3s ease;
        }

        select:focus {
            outline: none;
            border-color: #667eea;
        }

        .game-over {
            text-align: center;
            padding: 20px;
            background: #fff3cd;
            border-radius: 10px;
            border: 2px solid #ffc107;
            display: none;
            margin-bottom: 20px;
            animation: slideIn 0.3s ease;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .game-over h2 {
            color: #856404;
            margin-bottom: 10px;
            font-size: 1.8em;
        }

        .game-over p {
            color: #856404;
            font-size: 1.2em;
        }

        .instructions {
            text-align: center;
            color: #6c757d;
            margin-top: 15px;
            font-size: 0.9em;
        }

        @media (max-width: 600px) {
            .header h1 {
                font-size: 1.8em;
            }
            
            .stat-box {
                min-width: 100px;
                padding: 10px 15px;
            }

            #gameCanvas {
                width: 100%;
                height: auto;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1 id="gameTitle">🐍 Pro Snake Game</h1>
        </div>

        <div class="stats">
            <div class="stat-box">
                <div class="stat-label" id="scoreLabel">Score</div>
                <div class="stat-value" id="score">0</div>
            </div>
            <div class="stat-box">
                <div class="stat-label" id="levelLabel">Level</div>
                <div class="stat-value" id="level">1</div>
            </div>
            <div class="stat-box">
                <div class="stat-label" id="speedLabel">Speed</div>
                <div class="stat-value" id="speed">150ms</div>
            </div>
        </div>

        <div class="settings-panel">
            <div class="setting-row">
                <span class="setting-label" id="langLabel">Language / Langue / اللغة:</span>
                <select id="language">
                    <option value="en">English</option>
                    <option value="fr">Français</option>
                    <option value="ar">العربية</option>
                </select>
            </div>
            <div class="setting-row">
                <span class="setting-label" id="diffLabel">Difficulty:</span>
                <select id="difficulty">
                    <option value="easy">Easy</option>
                    <option value="medium" selected>Medium</option>
                    <option value="hard">Hard</option>
                    <option value="expert">Expert</option>
                </select>
            </div>
        </div>

        <div class="game-area">
            <canvas id="gameCanvas" width="400" height="400"></canvas>
        </div>

        <div class="game-over" id="gameOver">
            <h2 id="gameOverText">Game Over!</h2>
            <p id="finalScoreText">Final Score: <span id="finalScore">0</span></p>
        </div>

        <div class="controls">
            <button class="btn btn-primary" id="startBtn">▶ Play</button>
            <button class="btn btn-secondary" id="pauseBtn">⏸ Pause</button>
            <button class="btn btn-secondary" id="restartBtn">🔄 Restart</button>
        </div>

        <div class="instructions">
            <p id="instructions">🎮 Use Arrow Keys to move • Press SPACE to start/pause</p>
        </div>
    </div>

    <script>
        // Translations
        const translations = {
            en: {
                title: "🐍 Pro Snake Game",
                score: "Score",
                level: "Level",
                speed: "Speed",
                play: "▶ Play",
                pause: "⏸ Pause",
                restart: "🔄 Restart",
                gameOver: "Game Over!",
                finalScore: "Final Score",
                language: "Language / Langue / اللغة:",
                difficulty: "Difficulty:",
                easy: "Easy",
                medium: "Medium",
                hard: "Hard",
                expert: "Expert",
                instructions: "🎮 Use Arrow Keys to move • Press SPACE to start/pause"
            },
            fr: {
                title: "🐍 Jeu du Serpent Pro",
                score: "Score",
                level: "Niveau",
                speed: "Vitesse",
                play: "▶ Jouer",
                pause: "⏸ Pause",
                restart: "🔄 Recommencer",
                gameOver: "Jeu Terminé!",
                finalScore: "Score Final",
                language: "Language / Langue / اللغة:",
                difficulty: "Difficulté:",
                easy: "Facile",
                medium: "Moyen",
                hard: "Difficile",
                expert: "Expert",
                instructions: "🎮 Utilisez les flèches pour bouger • ESPACE pour démarrer/pause"
            },
            ar: {
                title: "🐍 لعبة الثعبان المحترفة",
                score: "النقاط",
                level: "المستوى",
                speed: "السرعة",
                play: "▶ العب",
                pause: "⏸ إيقاف",
                restart: "🔄 إعادة",
                gameOver: "!انتهت اللعبة",
                finalScore: "النتيجة النهائية",
                language: "Language / Langue / اللغة:",
                difficulty: ":الصعوبة",
                easy: "سهل",
                medium: "متوسط",
                hard: "صعب",
                expert: "خبير",
                instructions: "استخدم الأسهم للتحرك • مسافة للبدء/الإيقاف 🎮"
            }
        };

        // Game variables
        const canvas = document.getElementById('gameCanvas');
        const ctx = canvas.getContext('2d');
        const gridSize = 20;
        const tileCount = 20;
        
        let snake = [{x: 10, y: 10}];
        let food = {x: 15, y: 15};
        let dx = 0;
        let dy = 0;
        let score = 0;
        let level = 1;
        let gameSpeed = 150;
        let gameLoop;
        let isPlaying = false;
        let isPaused = false;
        let currentLang = 'en';
        let difficulty = 'medium';

        const difficultySpeed = {
            easy: 200,
            medium: 150,
            hard: 100,
            expert: 60
        };

        function updateLanguage() {
            currentLang = document.getElementById('language').value;
            const t = translations[currentLang];
            
            document.getElementById('gameTitle').textContent = t.title;
            document.getElementById('scoreLabel').textContent = t.score;
            document.getElementById('levelLabel').textContent = t.level;
            document.getElementById('speedLabel').textContent = t.speed;
            document.getElementById('startBtn').textContent = t.play;
            document.getElementById('pauseBtn').textContent = t.pause;
            document.getElementById('restartBtn').textContent = t.restart;
            document.getElementById('gameOverText').textContent = t.gameOver;
            document.getElementById('langLabel').textContent = t.language;
            document.getElementById('diffLabel').textContent = t.difficulty;
            document.getElementById('instructions').textContent = t.instructions;
            
            const diffSelect = document.getElementById('difficulty');
            diffSelect.options[0].text = t.easy;
            diffSelect.options[1].text = t.medium;
            diffSelect.options[2].text = t.hard;
            diffSelect.options[3].text = t.expert;
            
            document.getElementById('finalScoreText').innerHTML = 
                t.finalScore + ': <span id="finalScore">' + score + '</span>';
        }

        function drawGame() {
            // Clear canvas
            ctx.fillStyle = '#f8f9fa';
            ctx.fillRect(0, 0, canvas.width, canvas.height);
            
            // Draw grid
            ctx.strokeStyle = '#e9ecef';
            ctx.lineWidth = 1;
            for (let i = 0; i <= tileCount; i++) {
                ctx.beginPath();
                ctx.moveTo(i * gridSize, 0);
                ctx.lineTo(i * gridSize, canvas.height);
                ctx.stroke();
                ctx.beginPath();
                ctx.moveTo(0, i * gridSize);
                ctx.lineTo(canvas.width, i * gridSize);
                ctx.stroke();
            }
            
            // Draw snake
            snake.forEach((segment, index) => {
                const gradient = ctx.createLinearGradient(
                    segment.x * gridSize, segment.y * gridSize,
                    (segment.x + 1) * gridSize, (segment.y + 1) * gridSize
                );
                gradient.addColorStop(0, '#667eea');
                gradient.addColorStop(1, '#764ba2');
                ctx.fillStyle = gradient;
                ctx.fillRect(segment.x * gridSize + 1, segment.y * gridSize + 1, gridSize - 2, gridSize - 2);
                ctx.strokeStyle = '#fff';
                ctx.lineWidth = 2;
                ctx.strokeRect(segment.x * gridSize + 1, segment.y * gridSize + 1, gridSize - 2, gridSize - 2);
            });
            
            // Draw food
            ctx.fillStyle = '#ff6b6b';
            ctx.beginPath();
            ctx.arc(
                food.x * gridSize + gridSize / 2,
                food.y * gridSize + gridSize / 2,
                gridSize / 2 - 2,
                0,
                Math.PI * 2
            );
            ctx.fill();
            ctx.strokeStyle = '#ff5252';
            ctx.lineWidth = 2;
            ctx.stroke();
        }

        function moveSnake() {
            const head = {x: snake[0].x + dx, y: snake[0].y + dy};
            
            // Check wall collision
            if (head.x < 0 || head.x >= tileCount || head.y < 0 || head.y >= tileCount) {
                gameOver();
                return;
            }
            
            // Check self collision
            for (let segment of snake) {
                if (head.x === segment.x && head.y === segment.y) {
                    gameOver();
                    return;
                }
            }
            
            snake.unshift(head);
            
            // Check food collision
            if (head.x === food.x && head.y === food.y) {
                score += 10;
                level = Math.floor(score / 50) + 1;
                gameSpeed = Math.max(50, difficultySpeed[difficulty] - (level * 10));
                updateStats();
                generateFood();
                
                if (gameLoop) {
                    clearInterval(gameLoop);
                    gameLoop = setInterval(gameUpdate, gameSpeed);
                }
            } else {
                snake.pop();
            }
        }

        function generateFood() {
            food = {
                x: Math.floor(Math.random() * tileCount),
                y: Math.floor(Math.random() * tileCount)
            };
            
            // Make sure food doesn't spawn on snake
            for (let segment of snake) {
                if (food.x === segment.x && food.y === segment.y) {
                    generateFood();
                    return;
                }
            }
        }

        function gameUpdate() {
            if (!isPaused) {
                moveSnake();
                drawGame();
            }
        }

        function startGame() {
            if (!isPlaying) {
                isPlaying = true;
                isPaused = false;
                document.getElementById('gameOver').style.display = 'none';
                if (!dx && !dy) {
                    dx = 1;
                    dy = 0;
                }
                gameLoop = setInterval(gameUpdate, gameSpeed);
            }
        }

        function pauseGame() {
            isPaused = !isPaused;
            const t = translations[currentLang];
            document.getElementById('pauseBtn').textContent = isPaused ? '▶ ' + t.play.substring(2) : t.pause;
        }

        function restartGame() {
            clearInterval(gameLoop);
            snake = [{x: 10, y: 10}];
            dx = 0;
            dy = 0;
            score = 0;
            level = 1;
            difficulty = document.getElementById('difficulty').value;
            gameSpeed = difficultySpeed[difficulty];
            isPlaying = false;
            isPaused = false;
            updateStats();
            generateFood();
            drawGame();
            document.getElementById('gameOver').style.display = 'none';
            const t = translations[currentLang];
            document.getElementById('pauseBtn').textContent = t.pause;
        }

        function gameOver() {
            clearInterval(gameLoop);
            isPlaying = false;
            document.getElementById('gameOver').style.display = 'block';
            document.getElementById('finalScore').textContent = score;
        }

        function updateStats() {
            document.getElementById('score').textContent = score;
            document.getElementById('level').textContent = level;
            document.getElementById('speed').textContent = gameSpeed + 'ms';
        }

        // Event listeners
        document.getElementById('language').addEventListener('change', updateLanguage);
        document.getElementById('difficulty').addEventListener('change', function() {
            difficulty = this.value;
            if (!isPlaying) {
                gameSpeed = difficultySpeed[difficulty];
                updateStats();
            }
        });
        
        document.getElementById('startBtn').addEventListener('click', startGame);
        document.getElementById('pauseBtn').addEventListener('click', pauseGame);
        document.getElementById('restartBtn').addEventListener('click', restartGame);

        document.addEventListener('keydown', function(e) {
            if (e.code === 'Space') {
                e.preventDefault();
                if (!isPlaying) {
                    startGame();
                } else {
                    pauseGame();
                }
            }
            
            if (!isPlaying || isPaused) return;
            
            switch(e.key) {
                case 'ArrowUp':
                    if (dy === 0) { dx = 0; dy = -1; }
                    break;
                case 'ArrowDown':
                    if (dy === 0) { dx = 0; dy = 1; }
                    break;
                case 'ArrowLeft':
                    if (dx === 0) { dx = -1; dy = 0; }
                    break;
                case 'ArrowRight':
                    if (dx === 0) { dx = 1; dy = 0; }
                    break;
            }
        });

        // Initialize
        updateLanguage();
        updateStats();
        generateFood();
        drawGame();
    </script>
</body>
</html>
