# Refatorando o Dawn Forest   
1. A ideia é começar com um state machine com match e enum, coisa que não tinha no script original, para na próxima refatoração separar os scripts em arquivos *.gd e refazer o state machine.   
2. Não acredito que a separação em pastas diferentes para scenes e script ajude a compreensão, então mantenho na mesma pasta da cena o script por ela responsável
a não ser scripts compartilhados que serão mantidos em pastas de compartilhamento.
4. Eliminação de código desnecessário, remoção de chamadas call_group e referências espalhadas pelo projeto chamadas como: export(NodePath) onready var points_info = get_node(points_info) as TextureRect.   
5. Utilização de sinais e Event Bus no lugar dos outros tipos de chamada de código e funções.
