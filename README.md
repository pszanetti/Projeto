# Refatorando o Dawn Forest -> Lembrando: projeto para Godot 3.6.3   
1. A ideia é começar com um state machine com match e enum, coisa que não
 tinha no script original, para na próxima refatoração separar os scripts 
em arquivos *.gd e refazer o state machine.   
2. Não acredito que a separação em pastas diferentes para scenes e script
 ajude a compreensão, então mantenho na mesma pasta da cena
 o script por ela responsável
a não ser scripts compartilhados que serão mantidos em pastas de compartilhamento.
3. Eliminação de código desnecessário, remoção de chamadas call_group e referências
 espalhadas pelo projeto chamadas como: 
export(NodePath) onready var points_info = get_node(points_info) as TextureRect.   
4. A ser implementado a utilização de sinais e Event Bus no lugar dos outros 
tipos de chamada de código e funções, como as descritas no item 3.   


Obs.: uso da propriedade scale.x para 1 ou -1 para dar flip no player, mas lembando:    
#### Nodes de física NÃO PODEM usar isso !!!    
Então separei num Node2D (DirectionPivot) que é o responsável pelo flip do player:   
Segue a estrutura até agora:    

```text
Player (KinemmaticBody2D)
 ├── CollisionFloor (CollisionShape2D)
 ├── Animation (AnimationPlayer)
 ├── HitArea (Area2D)
 │    ├── HitCollision(CollisionShape2D)
 ├── Camera2D
 ├── DirectionPivot (Node2D)
 │    ├── WallRayCast (RayCast2D)
 │    ├─── AttackArea (Area2D)
 │    │     └── CollisionAttack (CollisionShape2D)
 │    └── Texture (Sprite2D)
 └------------------------------------

```
