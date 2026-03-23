function onCreate()

    -- background shit

    makeLuaSprite('sky', 'StageEvilD3/Sky', 300, 240);
	addLuaSprite('sky', false);
    setProperty('sky.visible', true)
	scaleObject('sky', 7, 7);
	setLuaSpriteScrollFactor('sky', 0.9, 0.9);
    
    makeLuaSprite('backschool', 'StageEvilD3/school', 80, 180);
	addLuaSprite('backschool', false);
    setProperty('backschool.visible', true)
	scaleObject('backschool', 7, 7);
	setLuaSpriteScrollFactor('backschool', 0.7, 1);

    makeLuaSprite('street', 'StageEvilD3/Street', 1, 1);
	addLuaSprite('street', false);
	scaleObject('street', 8.5, 8.5);
    setProperty('street.visible', true)
	setLuaSpriteScrollFactor('street', 1, 1);

	makeLuaSprite('tresss', 'StageEvilD3/TreesBack', 450, 325);
	addLuaSprite('tresss', false);
    setProperty('tresss.visible', true)
	scaleObject('tresss', 5.5, 5.5);
	setLuaSpriteScrollFactor('tresss', 1, 1);

	makeAnimatedLuaSprite('aaaa', 'StageEvilD3/Trees', 1, 220);
	addAnimationByPrefix('aaaa', 'bruh', 'Tress', 10, true);
	setGraphicSize('aaaa', getProperty('aaaa.width') * 8.5)
	setProperty('aaaa.visible', true);
	addLuaSprite('aaaa', false);

	makeAnimatedLuaSprite('petal3', 'StageEvilD3/petalsThorns', 1, 220);
	addAnimationByPrefix('petal3', 'bruuhh', 'PETALS ALL0', 24, true);
	objectPlayAnimation('petal3', 'bruuhh', true);
	setGraphicSize('petal3', getProperty('petal3.width') * 8.5)
	addLuaSprite('petal3', false);
	setObjectCamera('petal3', 'game');

	makeLuaSprite('margeD3', 'StageEvilD3/MargeD3', 1, 1);
	addLuaSprite('margeD3', false);
    setProperty('margeD3.visible', true)
	setObjectCamera('margeD3', 'hud');
	setLuaSpriteScrollFactor('skyd2', 1, 1);

	-- evil stage

	makeLuaSprite('skyevil', 'StageEvilD3/SkyEvil', 300, 240);
	addLuaSprite('skyevil', false);
    setProperty('skyevil.visible', false)
	scaleObject('skyevil', 7, 7);
	setLuaSpriteScrollFactor('skyevil', 1, 1);
    
    makeLuaSprite('backschoolevil', 'StageEvilD3/SchoolEvil', 80, 180);
	addLuaSprite('backschoolevil', false);
    setProperty('backschoolevil.visible', false)
	scaleObject('backschoolevil', 7, 7);
	setLuaSpriteScrollFactor('backschoolevil', 0.7, 1);

    makeLuaSprite('streetevil', 'StageEvilD3/StreetEvil', 1, 1);
	addLuaSprite('streetevil', false);
	scaleObject('streetevil', 8.5, 8.5);
    setProperty('streetevil.visible', false)
	setLuaSpriteScrollFactor('streetevil', 1, 1);
	
	makeLuaSprite('tresssevil', 'StageEvilD3/TreesBackEvil', 450, 325);
	addLuaSprite('tresssevil', false);
    setProperty('tresssevil.visible', false)
	scaleObject('tresssevil', 5.5, 5.5);
	setLuaSpriteScrollFactor('tresssevil', 1, 1);

	setProperty('sky.antialiasing', false)
	setProperty('backschool.antialiasing', false)
	setProperty('street.antialiasing', false)
	setProperty('tresss.antialiasing', false)
	setProperty('aaaa.antialiasing', false)
	setProperty('petal3.antialiasing', false)

	setProperty('skyevil.antialiasing', false)
	setProperty('backschoolevil.antialiasing', false)
	setProperty('streetevil.antialiasing', false)
	setProperty('tresssevil.antialiasing', false)

end

function onBeatHit()

	objectPlayAnimation('aaaa', 'Tress', true);

end