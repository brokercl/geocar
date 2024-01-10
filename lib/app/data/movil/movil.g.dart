// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movil.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMovilCollection on Isar {
  IsarCollection<Movil> get movils => this.collection();
}

const MovilSchema = CollectionSchema(
  name: r'Movil',
  id: -7302522310566456441,
  properties: {
    r'categoryMovil': PropertySchema(
      id: 0,
      name: r'categoryMovil',
      type: IsarType.byte,
      enumMap: _MovilcategoryMovilEnumValueMap,
    ),
    r'placa': PropertySchema(
      id: 1,
      name: r'placa',
      type: IsarType.string,
    )
  },
  estimateSize: _movilEstimateSize,
  serialize: _movilSerialize,
  deserialize: _movilDeserialize,
  deserializeProp: _movilDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'movilToUser': LinkSchema(
      id: -2925022236977044824,
      name: r'movilToUser',
      target: r'User',
      single: false,
      linkName: r'userLinksMovil',
    ),
    r'movilToPoint': LinkSchema(
      id: -8825259958183834689,
      name: r'movilToPoint',
      target: r'Point',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _movilGetId,
  getLinks: _movilGetLinks,
  attach: _movilAttach,
  version: '3.1.0+1',
);

int _movilEstimateSize(
  Movil object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.placa;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _movilSerialize(
  Movil object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByte(offsets[0], object.categoryMovil.index);
  writer.writeString(offsets[1], object.placa);
}

Movil _movilDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Movil(
    categoryMovil:
        _MovilcategoryMovilValueEnumMap[reader.readByteOrNull(offsets[0])] ??
            CategoryMovil.c,
    id: id,
    placa: reader.readStringOrNull(offsets[1]),
  );
  return object;
}

P _movilDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (_MovilcategoryMovilValueEnumMap[reader.readByteOrNull(offset)] ??
          CategoryMovil.c) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _MovilcategoryMovilEnumValueMap = {
  'c': 0,
  'b': 1,
  'r': 2,
};
const _MovilcategoryMovilValueEnumMap = {
  0: CategoryMovil.c,
  1: CategoryMovil.b,
  2: CategoryMovil.r,
};

Id _movilGetId(Movil object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _movilGetLinks(Movil object) {
  return [object.movilToUser, object.movilToPoint];
}

void _movilAttach(IsarCollection<dynamic> col, Id id, Movil object) {
  object.id = id;
  object.movilToUser
      .attach(col, col.isar.collection<User>(), r'movilToUser', id);
  object.movilToPoint
      .attach(col, col.isar.collection<Point>(), r'movilToPoint', id);
}

extension MovilQueryWhereSort on QueryBuilder<Movil, Movil, QWhere> {
  QueryBuilder<Movil, Movil, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MovilQueryWhere on QueryBuilder<Movil, Movil, QWhereClause> {
  QueryBuilder<Movil, Movil, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Movil, Movil, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Movil, Movil, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Movil, Movil, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Movil, Movil, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension MovilQueryFilter on QueryBuilder<Movil, Movil, QFilterCondition> {
  QueryBuilder<Movil, Movil, QAfterFilterCondition> categoryMovilEqualTo(
      CategoryMovil value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryMovil',
        value: value,
      ));
    });
  }

  QueryBuilder<Movil, Movil, QAfterFilterCondition> categoryMovilGreaterThan(
    CategoryMovil value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'categoryMovil',
        value: value,
      ));
    });
  }

  QueryBuilder<Movil, Movil, QAfterFilterCondition> categoryMovilLessThan(
    CategoryMovil value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'categoryMovil',
        value: value,
      ));
    });
  }

  QueryBuilder<Movil, Movil, QAfterFilterCondition> categoryMovilBetween(
    CategoryMovil lower,
    CategoryMovil upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'categoryMovil',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Movil, Movil, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Movil, Movil, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Movil, Movil, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Movil, Movil, QAfterFilterCondition> idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Movil, Movil, QAfterFilterCondition> idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Movil, Movil, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Movil, Movil, QAfterFilterCondition> placaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'placa',
      ));
    });
  }

  QueryBuilder<Movil, Movil, QAfterFilterCondition> placaIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'placa',
      ));
    });
  }

  QueryBuilder<Movil, Movil, QAfterFilterCondition> placaEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'placa',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Movil, Movil, QAfterFilterCondition> placaGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'placa',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Movil, Movil, QAfterFilterCondition> placaLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'placa',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Movil, Movil, QAfterFilterCondition> placaBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'placa',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Movil, Movil, QAfterFilterCondition> placaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'placa',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Movil, Movil, QAfterFilterCondition> placaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'placa',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Movil, Movil, QAfterFilterCondition> placaContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'placa',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Movil, Movil, QAfterFilterCondition> placaMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'placa',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Movil, Movil, QAfterFilterCondition> placaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'placa',
        value: '',
      ));
    });
  }

  QueryBuilder<Movil, Movil, QAfterFilterCondition> placaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'placa',
        value: '',
      ));
    });
  }
}

extension MovilQueryObject on QueryBuilder<Movil, Movil, QFilterCondition> {}

extension MovilQueryLinks on QueryBuilder<Movil, Movil, QFilterCondition> {
  QueryBuilder<Movil, Movil, QAfterFilterCondition> movilToUser(
      FilterQuery<User> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'movilToUser');
    });
  }

  QueryBuilder<Movil, Movil, QAfterFilterCondition> movilToUserLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'movilToUser', length, true, length, true);
    });
  }

  QueryBuilder<Movil, Movil, QAfterFilterCondition> movilToUserIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'movilToUser', 0, true, 0, true);
    });
  }

  QueryBuilder<Movil, Movil, QAfterFilterCondition> movilToUserIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'movilToUser', 0, false, 999999, true);
    });
  }

  QueryBuilder<Movil, Movil, QAfterFilterCondition> movilToUserLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'movilToUser', 0, true, length, include);
    });
  }

  QueryBuilder<Movil, Movil, QAfterFilterCondition>
      movilToUserLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'movilToUser', length, include, 999999, true);
    });
  }

  QueryBuilder<Movil, Movil, QAfterFilterCondition> movilToUserLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'movilToUser', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<Movil, Movil, QAfterFilterCondition> movilToPoint(
      FilterQuery<Point> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'movilToPoint');
    });
  }

  QueryBuilder<Movil, Movil, QAfterFilterCondition> movilToPointLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'movilToPoint', length, true, length, true);
    });
  }

  QueryBuilder<Movil, Movil, QAfterFilterCondition> movilToPointIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'movilToPoint', 0, true, 0, true);
    });
  }

  QueryBuilder<Movil, Movil, QAfterFilterCondition> movilToPointIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'movilToPoint', 0, false, 999999, true);
    });
  }

  QueryBuilder<Movil, Movil, QAfterFilterCondition> movilToPointLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'movilToPoint', 0, true, length, include);
    });
  }

  QueryBuilder<Movil, Movil, QAfterFilterCondition>
      movilToPointLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'movilToPoint', length, include, 999999, true);
    });
  }

  QueryBuilder<Movil, Movil, QAfterFilterCondition> movilToPointLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'movilToPoint', lower, includeLower, upper, includeUpper);
    });
  }
}

extension MovilQuerySortBy on QueryBuilder<Movil, Movil, QSortBy> {
  QueryBuilder<Movil, Movil, QAfterSortBy> sortByCategoryMovil() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryMovil', Sort.asc);
    });
  }

  QueryBuilder<Movil, Movil, QAfterSortBy> sortByCategoryMovilDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryMovil', Sort.desc);
    });
  }

  QueryBuilder<Movil, Movil, QAfterSortBy> sortByPlaca() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'placa', Sort.asc);
    });
  }

  QueryBuilder<Movil, Movil, QAfterSortBy> sortByPlacaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'placa', Sort.desc);
    });
  }
}

extension MovilQuerySortThenBy on QueryBuilder<Movil, Movil, QSortThenBy> {
  QueryBuilder<Movil, Movil, QAfterSortBy> thenByCategoryMovil() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryMovil', Sort.asc);
    });
  }

  QueryBuilder<Movil, Movil, QAfterSortBy> thenByCategoryMovilDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryMovil', Sort.desc);
    });
  }

  QueryBuilder<Movil, Movil, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Movil, Movil, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Movil, Movil, QAfterSortBy> thenByPlaca() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'placa', Sort.asc);
    });
  }

  QueryBuilder<Movil, Movil, QAfterSortBy> thenByPlacaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'placa', Sort.desc);
    });
  }
}

extension MovilQueryWhereDistinct on QueryBuilder<Movil, Movil, QDistinct> {
  QueryBuilder<Movil, Movil, QDistinct> distinctByCategoryMovil() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoryMovil');
    });
  }

  QueryBuilder<Movil, Movil, QDistinct> distinctByPlaca(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'placa', caseSensitive: caseSensitive);
    });
  }
}

extension MovilQueryProperty on QueryBuilder<Movil, Movil, QQueryProperty> {
  QueryBuilder<Movil, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Movil, CategoryMovil, QQueryOperations> categoryMovilProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryMovil');
    });
  }

  QueryBuilder<Movil, String?, QQueryOperations> placaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'placa');
    });
  }
}
