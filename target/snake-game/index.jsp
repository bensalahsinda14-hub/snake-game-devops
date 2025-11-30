import React, { useState, useEffect, useCallback, useRef } from 'react';

const GRID_SIZE = 20;
const CELL_SIZE = 20;
const INITIAL_SNAKE = [[10, 10]];
const INITIAL_DIRECTION = { x: 1, y: 0 };

const TRANSLATIONS = {
  ar: {
    title: 'Snake Master',
    start: 'ابدأ اللعبة',
    startAdventure: 'ابدأ المغامرة!',
    playAgain: 'العب مرة أخرى',
    gameOver: 'Game Over!',
    paused: 'متوقف مؤقتاً',
    pressP: 'اضغط P للمتابعة',
    score: 'النقاط',
    highScore: 'الأعلى',
    level: 'المستوى',
    finalScore: 'النقاط النهائية',
    newRecord: 'رقم قياسي جديد!',
    settings: 'الإعدادات',
    difficulty: 'الصعوبة:',
    customSpeed: 'سرعة مخصصة:',
    veryFast: 'سريع جداً',
    slow: 'بطيء',
    controls: 'WASD أو الأسهم',
    pauseKey: 'P للإيقاف',
    foodInfo: 'كل تفاحة = 10 نقاط • اجمع النقاط لفتح المستويات!',
    nextLevel: 'للمستوى التالي',
    difficulties: {
      facile: 'سهل',
      moyen: 'متوسط',
      difficile: 'صعب',
      expert: 'خبير'
    },
    levels: [
      { name: 'المبتدئ', reward: 'ممتاز!' },
      { name: 'المتوسط', reward: 'رائع!' },
      { name: 'المحترف', reward: 'لا يصدق!' },
      { name: 'الخبير', reward: 'أسطوري!' },
      { name: 'البطل', reward: 'خارق!' },
      { name: 'الأسطورة', reward: 'إلهي! 🔥' }
    ]
  },
  fr: {
    title: 'Snake Master',
    start: 'Commencer',
    startAdventure: 'Commencez l\'aventure!',
    playAgain: 'Rejouer',
    gameOver: 'Game Over!',
    paused: 'Pause',
    pressP: 'Appuyez sur P pour continuer',
    score: 'Score',
    highScore: 'Meilleur',
    level: 'Niveau',
    finalScore: 'Score Final',
    newRecord: 'Nouveau record!',
    settings: 'Paramètres',
    difficulty: 'Difficulté:',
    customSpeed: 'Vitesse personnalisée:',
    veryFast: 'Très rapide',
    slow: 'Lent',
    controls: 'WASD ou Flèches',
    pauseKey: 'P pour pause',
    foodInfo: 'Chaque pomme = 10 points • Collectez des points pour débloquer les niveaux!',
    nextLevel: 'pour le niveau suivant',
    difficulties: {
      facile: 'Facile',
      moyen: 'Moyen',
      difficile: 'Difficile',
      expert: 'Expert'
    },
    levels: [
      { name: 'Débutant', reward: 'Excellent!' },
      { name: 'Intermédiaire', reward: 'Super!' },
      { name: 'Professionnel', reward: 'Incroyable!' },
      { name: 'Expert', reward: 'Légendaire!' },
      { name: 'Champion', reward: 'Extraordinaire!' },
      { name: 'Légende', reward: 'Divin! 🔥' }
    ]
  },
  en: {
    title: 'Snake Master',
    start: 'Start Game',
    startAdventure: 'Start the Adventure!',
    playAgain: 'Play Again',
    gameOver: 'Game Over!',
    paused: 'Paused',
    pressP: 'Press P to continue',
    score: 'Score',
    highScore: 'Best',
    level: 'Level',
    finalScore: 'Final Score',
    newRecord: 'New Record!',
    settings: 'Settings',
    difficulty: 'Difficulty:',
    customSpeed: 'Custom Speed:',
    veryFast: 'Very Fast',
    slow: 'Slow',
    controls: 'WASD or Arrows',
    pauseKey: 'P to pause',
    foodInfo: 'Each apple = 10 points • Collect points to unlock levels!',
    nextLevel: 'to next level',
    difficulties: {
      facile: 'Easy',
      moyen: 'Medium',
      difficile: 'Hard',
      expert: 'Expert'
    },
    levels: [
      { name: 'Beginner', reward: 'Excellent!' },
      { name: 'Intermediate', reward: 'Amazing!' },
      { name: 'Professional', reward: 'Incredible!' },
      { name: 'Expert', reward: 'Legendary!' },
      { name: 'Champion', reward: 'Extraordinary!' },
      { name: 'Legend', reward: 'Divine! 🔥' }
    ]
  }
};

const DIFFICULTIES = {
  facile: { speed: 200, color: 'from-green-400 to-emerald-500' },
  moyen: { speed: 130, color: 'from-yellow-400 to-orange-500' },
  difficile: { speed: 80, color: 'from-orange-400 to-red-500' },
  expert: { speed: 50, color: 'from-red-500 to-purple-600' }
};

const LEVELS = [
  { level: 1, target: 50 },
  { level: 2, target: 120 },
  { level: 3, target: 200 },
  { level: 4, target: 300 },
  { level: 5, target: 450 },
  { level: 6, target: 650 }
];

const SnakeGame = () => {
  const [snake, setSnake] = useState(INITIAL_SNAKE);
  const [food, setFood] = useState({ x: 15, y: 15 });
  const [direction, setDirection] = useState(INITIAL_DIRECTION);
  const [nextDirection, setNextDirection] = useState(INITIAL_DIRECTION);
  const [gameOver, setGameOver] = useState(false);
  const [score, setScore] = useState(0);
  const [highScore, setHighScore] = useState(() => {
    const saved = localStorage.getItem('snakeHighScore');
    return saved ? parseInt(saved) : 0;
  });
  const [language, setLanguage] = useState(() => {
    const saved = localStorage.getItem('snakeLanguage');
    return saved || 'ar';
  });
  const [gameStarted, setGameStarted] = useState(false);
  const [isPaused, setIsPaused] = useState(false);
  const [difficulty, setDifficulty] = useState('moyen');
  const [customSpeed, setCustomSpeed] = useState(130);
  const [useCustomSpeed, setUseCustomSpeed] = useState(false);
  const [currentLevel, setCurrentLevel] = useState(1);
  const [showLevelUp, setShowLevelUp] = useState(false);
  const [particles, setParticles] = useState([]);
  const [showSettings, setShowSettings] = useState(false);

  const gameLoopRef = useRef(null);

  const t = TRANSLATIONS[language];
  const speed = useCustomSpeed ? customSpeed : DIFFICULTIES[difficulty].speed;

  const changeLanguage = (lang) => {
    setLanguage(lang);
    localStorage.setItem('snakeLanguage', lang);
  };

  const generateFood = useCallback(() => {
    let newFood;
    do {
      newFood = {
        x: Math.floor(Math.random() * GRID_SIZE),
        y: Math.floor(Math.random() * GRID_SIZE)
      };
    } while (snake.some(segment => segment[0] === newFood.x && segment[1] === newFood.y));
    return newFood;
  }, [snake]);

  const createParticles = (x, y) => {
    const newParticles = Array.from({ length: 12 }, (_, i) => ({
      id: Date.now() + i,
      x: x * CELL_SIZE + CELL_SIZE / 2,
      y: y * CELL_SIZE + CELL_SIZE / 2,
      angle: (Math.PI * 2 * i) / 12,
      speed: 2 + Math.random() * 2
    }));
    setParticles(prev => [...prev, ...newParticles]);
    setTimeout(() => {
      setParticles(prev => prev.filter(p => !newParticles.find(np => np.id === p.id)));
    }, 500);
  };

  const resetGame = () => {
    setSnake(INITIAL_SNAKE);
    setFood(generateFood());
    setDirection(INITIAL_DIRECTION);
    setNextDirection(INITIAL_DIRECTION);
    setGameOver(false);
    setScore(0);
    setGameStarted(true);
    setIsPaused(false);
    setCurrentLevel(1);
    setShowLevelUp(false);
    setParticles([]);
  };

  const moveSnake = useCallback(() => {
    if (gameOver || !gameStarted || isPaused) return;

    setDirection(nextDirection);

    setSnake(prevSnake => {
      const head = prevSnake[0];
      const newHead = [head[0] + nextDirection.x, head[1] + nextDirection.y];

      if (newHead[0] < 0 || newHead[0] >= GRID_SIZE || newHead[1] < 0 || newHead[1] >= GRID_SIZE) {
        setGameOver(true);
        return prevSnake;
      }

      if (prevSnake.some(segment => segment[0] === newHead[0] && segment[1] === newHead[1])) {
        setGameOver(true);
        return prevSnake;
      }

      const newSnake = [newHead, ...prevSnake];

      if (newHead[0] === food.x && newHead[1] === food.y) {
        const newScore = score + 10;
        setScore(newScore);
        createParticles(food.x, food.y);
        setFood(generateFood());
        
        const nextLevel = LEVELS.find(l => newScore >= l.target && l.level > currentLevel);
        if (nextLevel) {
          setCurrentLevel(nextLevel.level);
          setShowLevelUp(true);
          setTimeout(() => setShowLevelUp(false), 2000);
        }
        
        if (newScore > highScore) {
          setHighScore(newScore);
          localStorage.setItem('snakeHighScore', newScore.toString());
        }
        
        return newSnake;
      }

      newSnake.pop();
      return newSnake;
    });
  }, [nextDirection, food, gameOver, gameStarted, score, highScore, generateFood, isPaused, currentLevel]);

  useEffect(() => {
    const handleKeyPress = (e) => {
      if (!gameStarted && e.key === ' ') {
        resetGame();
        return;
      }

      if (e.key === 'p' || e.key === 'P') {
        setIsPaused(prev => !prev);
        return;
      }

      if (gameOver || isPaused) return;

      const key = e.key.toLowerCase();
      
      if ((key === 'arrowup' || key === 'w') && direction.y === 0) {
        setNextDirection({ x: 0, y: -1 });
      } else if ((key === 'arrowdown' || key === 's') && direction.y === 0) {
        setNextDirection({ x: 0, y: 1 });
      } else if ((key === 'arrowleft' || key === 'a') && direction.x === 0) {
        setNextDirection({ x: -1, y: 0 });
      } else if ((key === 'arrowright' || key === 'd') && direction.x === 0) {
        setNextDirection({ x: 1, y: 0 });
      }
    };

    window.addEventListener('keydown', handleKeyPress);
    return () => window.removeEventListener('keydown', handleKeyPress);
  }, [direction, gameOver, gameStarted, isPaused]);

  useEffect(() => {
    if (gameLoopRef.current) {
      clearInterval(gameLoopRef.current);
    }
    gameLoopRef.current = setInterval(moveSnake, speed);
    return () => {
      if (gameLoopRef.current) {
        clearInterval(gameLoopRef.current);
      }
    };
  }, [moveSnake, speed]);

  const currentLevelData = LEVELS.find(l => l.level === currentLevel) || LEVELS[0];
  const nextLevelData = LEVELS.find(l => l.level === currentLevel + 1);
  const progress = nextLevelData ? Math.min((score / nextLevelData.target) * 100, 100) : 100;

  const currentLevelName = t.levels[currentLevel - 1]?.name || '';
  const nextLevelName = t.levels[currentLevel]?.name || '';
  const currentLevelReward = t.levels[currentLevel - 1]?.reward || '';

  const getEyePosition = () => {
    if (direction.x === 1) return { left1: '70%', top1: '30%', left2: '70%', top2: '70%' };
    if (direction.x === -1) return { left1: '30%', top1: '30%', left2: '30%', top2: '70%' };
    if (direction.y === 1) return { left1: '30%', top1: '70%', left2: '70%', top2: '70%' };
    return { left1: '30%', top1: '30%', left2: '70%', top2: '30%' };
  };

  const eyePos = getEyePosition();

  return (
    <div className="flex items-center justify-center min-h-screen bg-gradient-to-br from-indigo-950 via-purple-950 to-pink-950 p-8 relative overflow-hidden">
      <div className="absolute inset-0 opacity-20">
        <div className="absolute top-20 left-20 w-96 h-96 bg-purple-500 rounded-full filter blur-3xl animate-pulse"></div>
        <div className="absolute bottom-20 right-20 w-96 h-96 bg-pink-500 rounded-full filter blur-3xl animate-pulse" style={{animationDelay: '1s'}}></div>
      </div>

      <div className="relative z-10 bg-black/40 backdrop-blur-xl rounded-3xl p-8 shadow-2xl border border-white/10 max-w-2xl w-full mx-auto">
        <div className="flex items-center justify-between mb-6">
          <h1 className="text-4xl md:text-5xl font-bold bg-gradient-to-r from-green-400 via-emerald-400 to-teal-400 bg-clip-text text-transparent drop-shadow-lg">
            🐍 {t.title}
          </h1>
          <div className="flex gap-2">
            <div className="flex gap-1 bg-white/10 backdrop-blur rounded-xl p-1">
              <button
                onClick={() => changeLanguage('ar')}
                className={`px-3 py-2 rounded-lg transition-all ${
                  language === 'ar' ? 'bg-white/20 text-white' : 'text-white/60 hover:text-white'
                }`}
                title="العربية"
              >
                🇹🇳 AR
              </button>
              <button
                onClick={() => changeLanguage('fr')}
                className={`px-3 py-2 rounded-lg transition-all ${
                  language === 'fr' ? 'bg-white/20 text-white' : 'text-white/60 hover:text-white'
                }`}
                title="Français"
              >
                🇫🇷 FR
              </button>
              <button
                onClick={() => changeLanguage('en')}
                className={`px-3 py-2 rounded-lg transition-all ${
                  language === 'en' ? 'bg-white/20 text-white' : 'text-white/60 hover:text-white'
                }`}
                title="English"
              >
                🇬🇧 EN
              </button>
            </div>
            <button
              onClick={() => setShowSettings(!showSettings)}
              className="p-3 bg-white/10 hover:bg-white/20 rounded-xl transition-all backdrop-blur"
            >
              <span className="text-2xl">⚙️</span>
            </button>
          </div>
        </div>

        {showSettings && (
          <div className="mb-6 bg-white/5 backdrop-blur rounded-2xl p-6 border border-white/10 space-y-4">
            <h3 className="text-xl font-bold text-white mb-4">⚙️ {t.settings}</h3>
            
            <div>
              <label className="text-white font-semibold mb-2 block">{t.difficulty}</label>
              <div className="grid grid-cols-2 gap-3">
                {Object.entries(DIFFICULTIES).map(([key, diff]) => (
                  <button
                    key={key}
                    onClick={() => {
                      setDifficulty(key);
                      setUseCustomSpeed(false);
                    }}
                    disabled={gameStarted && !gameOver}
                    className={`px-4 py-3 rounded-xl font-bold transition-all transform hover:scale-105 ${
                      difficulty === key && !useCustomSpeed
                        ? `bg-gradient-to-r ${diff.color} text-white shadow-lg`
                        : 'bg-white/10 text-white/70 hover:bg-white/20'
                    } ${gameStarted && !gameOver ? 'opacity-50 cursor-not-allowed' : ''}`}
                  >
                    {t.difficulties[key]}
                  </button>
                ))}
              </div>
            </div>

            <div>
              <label className="text-white font-semibold mb-2 block">
                {t.customSpeed} {customSpeed}ms
              </label>
              <input
                type="range"
                min="30"
                max="300"
                value={customSpeed}
                onChange={(e) => {
                  setCustomSpeed(parseInt(e.target.value));
                  setUseCustomSpeed(true);
                }}
                disabled={gameStarted && !gameOver}
                className="w-full h-2 bg-white/20 rounded-lg appearance-none cursor-pointer slider"
              />
              <div className="flex justify-between text-xs text-white/50 mt-1">
                <span>{t.veryFast}</span>
                <span>{t.slow}</span>
              </div>
            </div>
          </div>
        )}
        
        <div className="flex gap-4 mb-6">
          <div className="flex-1 bg-gradient-to-r from-green-500/20 to-emerald-500/20 backdrop-blur px-6 py-4 rounded-2xl border border-green-500/30">
            <div className="text-sm text-green-300 mb-1">{t.score}</div>
            <div className="text-3xl font-bold text-white">{score}</div>
          </div>
          <div className="flex-1 bg-gradient-to-r from-yellow-500/20 to-orange-500/20 backdrop-blur px-6 py-4 rounded-2xl border border-yellow-500/30">
            <div className="text-sm text-yellow-300 mb-1">{t.highScore}</div>
            <div className="text-3xl font-bold text-white">{highScore}</div>
          </div>
          <div className="flex-1 bg-gradient-to-r from-purple-500/20 to-pink-500/20 backdrop-blur px-6 py-4 rounded-2xl border border-purple-500/30">
            <div className="text-sm text-purple-300 mb-1">{t.level}</div>
            <div className="text-3xl font-bold text-white">{currentLevel}</div>
          </div>
        </div>

        {nextLevelData && (
          <div className="mb-6 bg-white/5 backdrop-blur rounded-2xl p-4 border border-white/10">
            <div className="flex justify-between text-sm text-white/70 mb-2">
              <span>{currentLevelName}</span>
              <span>{nextLevelName}</span>
            </div>
            <div className="w-full bg-white/10 rounded-full h-4 overflow-hidden">
              <div 
                className="h-full bg-gradient-to-r from-green-400 via-emerald-400 to-teal-400 transition-all duration-300 rounded-full"
                style={{ width: `${progress}%` }}
              ></div>
            </div>
            <div className="text-center text-xs text-white/50 mt-2">
              {score} / {nextLevelData.target} {t.nextLevel}
            </div>
          </div>
        )}

        <div 
          className="relative bg-gradient-to-br from-gray-900 to-black rounded-2xl shadow-2xl border-4 border-white/20 overflow-hidden mx-auto"
          style={{ 
            width: GRID_SIZE * CELL_SIZE, 
            height: GRID_SIZE * CELL_SIZE 
          }}
        >
          {Array.from({ length: GRID_SIZE }).map((_, row) =>
            Array.from({ length: GRID_SIZE }).map((_, col) => (
              <div
                key={`${row}-${col}`}
                className="absolute"
                style={{
                  left: col * CELL_SIZE,
                  top: row * CELL_SIZE,
                  width: CELL_SIZE,
                  height: CELL_SIZE,
                  backgroundColor: (row + col) % 2 === 0 ? 'rgba(255,255,255,0.02)' : 'transparent'
                }}
              />
            ))
          )}

          {snake.map((segment, index) => (
            <div
              key={index}
              className="absolute rounded-lg transition-all duration-75"
              style={{
                left: segment[0] * CELL_SIZE + 1,
                top: segment[1] * CELL_SIZE + 1,
                width: CELL_SIZE - 2,
                height: CELL_SIZE - 2,
                background: index === 0 
                  ? 'linear-gradient(135deg, #10b981 0%, #059669 100%)'
                  : `linear-gradient(135deg, #6ee7b7 0%, #34d399 100%)`,
                boxShadow: index === 0 ? '0 0 20px #10b981, inset 0 0 10px rgba(255,255,255,0.3)' : '0 0 10px #6ee7b7',
              }}
            >
              {index === 0 && (
                <>
                  <div className="absolute rounded-full bg-white transition-all duration-100"
                    style={{
                      left: eyePos.left1,
                      top: eyePos.top1,
                      width: '5px',
                      height: '5px',
                      transform: 'translate(-50%, -50%)'
                    }}
                  >
                    <div className="absolute inset-0 rounded-full bg-black" style={{width: '3px', height: '3px', margin: '1px'}}></div>
                  </div>
                  <div className="absolute rounded-full bg-white transition-all duration-100"
                    style={{
                      left: eyePos.left2,
                      top: eyePos.top2,
                      width: '5px',
                      height: '5px',
                      transform: 'translate(-50%, -50%)'
                    }}
                  >
                    <div className="absolute inset-0 rounded-full bg-black" style={{width: '3px', height: '3px', margin: '1px'}}></div>
                  </div>
                </>
              )}
            </div>
          ))}

          <div
            className="absolute rounded-full animate-pulse"
            style={{
              left: food.x * CELL_SIZE + 1,
              top: food.y * CELL_SIZE + 1,
              width: CELL_SIZE - 2,
              height: CELL_SIZE - 2,
              background: 'radial-gradient(circle, #ef4444 0%, #dc2626 100%)',
              boxShadow: '0 0 30px #ef4444, inset 0 0 10px rgba(255,255,255,0.5)',
            }}
          >
            <div className="absolute inset-0 rounded-full animate-ping bg-red-400 opacity-75"></div>
          </div>

          {particles.map(p => (
            <div
              key={p.id}
              className="absolute rounded-full bg-yellow-400 animate-ping"
              style={{
                left: p.x + Math.cos(p.angle) * p.speed * 10,
                top: p.y + Math.sin(p.angle) * p.speed * 10,
                width: '6px',
                height: '6px',
                boxShadow: '0 0 10px #fbbf24'
              }}
            />
          ))}

          {showLevelUp && (
            <div className="absolute inset-0 bg-gradient-to-r from-purple-600/80 to-pink-600/80 flex items-center justify-center backdrop-blur-sm animate-pulse z-50">
              <div className="text-center transform scale-110">
                <div className="text-6xl mb-4">🎉</div>
                <h2 className="text-4xl font-bold text-white drop-shadow-lg mb-2">
                  {t.level} {currentLevel}!
                </h2>
                <p className="text-2xl text-yellow-300 font-bold">
                  {currentLevelReward}
                </p>
              </div>
            </div>
          )}

          {gameOver && (
            <div className="absolute inset-0 bg-black/90 backdrop-blur-md flex items-center justify-center rounded-2xl z-40">
              <div className="text-center transform scale-110 animate-pulse">
                <div className="text-6xl mb-4">💀</div>
                <h2 className="text-5xl font-bold bg-gradient-to-r from-red-500 to-pink-500 bg-clip-text text-transparent mb-4">
                  {t.gameOver}
                </h2>
                <div className="bg-white/10 backdrop-blur rounded-xl p-6 mb-6 border border-white/20">
                  <p className="text-2xl text-white mb-2">{t.finalScore}</p>
                  <p className="text-5xl font-bold text-green-400">{score}</p>
                  <p className="text-lg text-white/70 mt-2">{t.level}: {currentLevel} - {currentLevelName}</p>
                </div>
                {score === highScore && score > 0 && (
                  <div className="mb-4 animate-bounce">
                    <p className="text-2xl text-yellow-400 font-bold">🏆 {t.newRecord}</p>
                  </div>
                )}
                <button
                  onClick={resetGame}
                  className="bg-gradient-to-r from-green-500 to-emerald-600 hover:from-green-600 hover:to-emerald-700 text-white font-bold py-4 px-10 rounded-xl text-xl transition-all transform hover:scale-105 shadow-lg"
                >
                  {t.playAgain}
                </button>
              </div>
            </div>
          )}

          {isPaused && !gameOver && gameStarted && (
            <div className="absolute inset-0 bg-black/70 backdrop-blur-sm flex items-center justify-center rounded-2xl z-30">
              <div className="text-center">
                <div className="text-6xl mb-4 animate-pulse">⏸️</div>
                <h2 className="text-4xl font-bold text-white mb-4">{t.paused}</h2>
                <p className="text-xl text-white/80">{t.pressP}</p>
              </div>
            </div>
          )}

          {!gameStarted && (
            <div className="absolute inset-0 bg-gradient-to-br from-purple-900/95 to-pink-900/95 backdrop-blur-md flex items-center justify-center rounded-2xl z-40">
              <div className="text-center">
                <div className="text-7xl mb-6 animate-bounce">🎮</div>
                <h2 className="text-5xl font-bold bg-gradient-to-r from-green-400 to-emerald-400 bg-clip-text text-transparent mb-8">
                  {t.startAdventure}
                </h2>
                <button
                  onClick={resetGame}
                  className="bg-gradient-to-r from-green-500 to-emerald-600 hover:from-green-600 hover:to-emerald-700 text-white font-bold py-5 px-12 rounded-2xl text-2xl transition-all transform hover:scale-110 shadow-2xl"
                >
                  ▶️ {t.start}
                </button>
              </div>
            </div>
          )}
        </div>

        <div className="mt-6 text-center space-y-3">
          <div className="flex items-center justify-center gap-6 text-white/90">
            <div className="flex items-center gap-2">
              <span className="text-2xl">⌨️</span>
              <span>{t.controls}</span>
            </div>
            <div className="flex items-center gap-2">
              <span className="text-2xl">⏸️</span>
              <span>{t.pauseKey}</span>
            </div>
          </div>
          <div className="text-white/60 text-sm">
            {t.foodInfo}
          </div>
        </div>
      </div>
    </div>
  );
};

export default SnakeGame;   
