extends Node

const GRAVITY : float = 1000.0

func apply_gravity(entity : CharacterBody2D, delta : float) -> void:
		entity.velocity.y += GRAVITY * delta
