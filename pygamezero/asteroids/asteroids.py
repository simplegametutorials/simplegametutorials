import pgzrun



import math
import random

arena_width = 800
arena_height = 600

ship_radius = 30

bullet_timer_limit = 0.5
bullet_radius = 5

asteroid_stages = [
    {
        'speed': 120,
        'radius': 15,
    },
    {
        'speed': 70,
        'radius': 30,
    },
    {
        'speed': 50,
        'radius': 50,
    },
    {
        'speed': 20,
        'radius': 80,
    },
]

def reset():
    global ship_x
    global ship_y
    global ship_speed_x
    global ship_speed_y
    global ship_angle
    global bullet_timer
    global bullets
    global asteroids

    ship_x = arena_width / 2
    ship_y = arena_height / 2
    ship_speed_x = 0
    ship_speed_y = 0
    ship_angle = 0

    bullets = []
    bullet_timer = bullet_timer_limit

    asteroids = [
        {
            'x': 100,
            'y': 100,
        },
        {
            'x': arena_width - 100,
            'y': 100,
        },
        {
            'x': arena_width / 2,
            'y': arena_height - 100,
        }
    ]

    for asteroid in asteroids:
        asteroid['angle'] = random.random() * (2 * math.pi)
        asteroid['stage'] = len(asteroid_stages) - 1

reset()

def update(dt):
    global ship_x
    global ship_y
    global ship_speed_x
    global ship_speed_y
    global ship_angle
    global bullet_timer

    turn_speed = 10

    if keyboard.right:
        ship_angle += turn_speed * dt

    if keyboard.left:
        ship_angle -= turn_speed * dt

    ship_angle %= 2 * math.pi

    if keyboard.up:
        ship_speed = 100
        ship_speed_x += math.cos(ship_angle) * ship_speed * dt
        ship_speed_y += math.sin(ship_angle) * ship_speed * dt

    ship_x += ship_speed_x * dt
    ship_y += ship_speed_y * dt

    ship_x %= arena_width
    ship_y %= arena_height

    def are_circles_intersecting(a_x, a_y, a_radius, b_x, b_y, b_radius):
        return (a_x - b_x)**2 + (a_y - b_y)**2 <= (a_radius + b_radius)**2

    for bullet in bullets.copy():
        bullet['time_left'] -= dt

        if bullet['time_left'] <= 0:
            bullets.remove(bullet)
            continue

        bullet_speed = 500
        bullet['x'] += math.cos(bullet['angle']) * bullet_speed * dt
        bullet['y'] += math.sin(bullet['angle']) * bullet_speed * dt
        bullet['x'] %= arena_width
        bullet['y'] %= arena_height

        for asteroid in asteroids.copy():
            if are_circles_intersecting(
                bullet['x'], bullet['y'], bullet_radius,
                asteroid['x'], asteroid['y'],
                asteroid_stages[asteroid['stage']]['radius']
            ):
                bullets.remove(bullet)

                if asteroid['stage'] > 0:
                    angle1 = random.random() * (2 * math.pi)
                    angle2 = (angle1 - math.pi) % (2 * math.pi)

                    asteroids.append({
                        'x': asteroid['x'],
                        'y': asteroid['y'],
                        'angle': angle1,
                        'stage': asteroid['stage'] - 1
                    })

                    asteroids.append({
                        'x': asteroid['x'],
                        'y': asteroid['y'],
                        'angle': angle2,
                        'stage': asteroid['stage'] - 1
                    })

                asteroids.remove(asteroid)

                break

    bullet_timer += dt

    if keyboard.S:
        if bullet_timer >= bullet_timer_limit:
            bullet_timer = 0

            bullets.append({
                'x': ship_x + math.cos(ship_angle) * ship_radius,
                'y': ship_y + math.sin(ship_angle) * ship_radius,
                'angle': ship_angle,
                'time_left': 4,
            })

    for asteroid in asteroids:
        asteroid_speed = asteroid_stages[asteroid['stage']]['speed']
        asteroid['x'] += math.cos(asteroid['angle']) * asteroid_speed * dt
        asteroid['y'] += math.sin(asteroid['angle']) * asteroid_speed * dt
        asteroid['x'] %= arena_width
        asteroid['y'] %= arena_height

        if are_circles_intersecting(
            ship_x, ship_y, ship_radius,
            asteroid['x'], asteroid['y'],
            asteroid_stages[asteroid['stage']]['radius']
        ):
            reset()

    if len(asteroids) == 0:
        reset()

def draw():
    screen.fill((0, 0, 0))

    for y in range(-1, 2):
        for x in range(-1, 2):
            offset_x = x * arena_width
            offset_y = y * arena_height

            screen.draw.filled_circle((
                ship_x + offset_x,
                ship_y + offset_y
            ), ship_radius, (0, 0, 255))

            ship_circle_distance = 20
            screen.draw.filled_circle((
                ship_x + offset_x +
                    math.cos(ship_angle) * ship_circle_distance,
                ship_y + offset_y +
                    math.sin(ship_angle) * ship_circle_distance,
            ), 5, (0, 255, 255))

            for bullet in bullets:
                screen.draw.filled_circle((
                    bullet['x'] + offset_x, bullet['y'] + offset_y
                ), bullet_radius, (0, 255, 0))

            for asteroid in asteroids:
                screen.draw.filled_circle(
                    (asteroid['x'] + offset_x, asteroid['y'] + offset_y),
                    asteroid_stages[asteroid['stage']]['radius'], (255, 255, 0)
                )



pgzrun.go()
