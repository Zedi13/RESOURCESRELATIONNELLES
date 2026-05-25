class TypeRelationEntity {
  final String id;
  final String libelle;
  final String description;
  final int ordre;

  const TypeRelationEntity({
    required this.id,
    required this.libelle,
    required this.description,
    required this.ordre,
  });

  TypeRelationEntity copyWith({
    String? libelle,
    String? description,
    int? ordre,
  }) {
    return TypeRelationEntity(
      id: id,
      libelle: libelle ?? this.libelle,
      description: description ?? this.description,
      ordre: ordre ?? this.ordre,
    );
  }
}
