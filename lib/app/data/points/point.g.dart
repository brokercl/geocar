// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPointCollection on Isar {
  IsarCollection<Point> get points => this.collection();
}

const PointSchema = CollectionSchema(
  name: r'Point',
  id: -1948583515862884236,
  properties: {
    r'date': PropertySchema(
      id: 0,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'tariff': PropertySchema(
      id: 1,
      name: r'tariff',
      type: IsarType.double,
    )
  },
  estimateSize: _pointEstimateSize,
  serialize: _pointSerialize,
  deserialize: _pointDeserialize,
  deserializeProp: _pointDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'pointToMovil': LinkSchema(
      id: -2477536161705281537,
      name: r'pointToMovil',
      target: r'Movil',
      single: false,
      linkName: r'movilToPoint',
    )
  },
  embeddedSchemas: {},
  getId: _pointGetId,
  getLinks: _pointGetLinks,
  attach: _pointAttach,
  version: '3.1.0+1',
);

int _pointEstimateSize(
  Point object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _pointSerialize(
  Point object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.date);
  writer.writeDouble(offsets[1], object.tariff);
}

Point _pointDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Point(
    date: reader.readDateTimeOrNull(offsets[0]),
    id: id,
    tariff: reader.readDouble(offsets[1]),
  );
  return object;
}

P _pointDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _pointGetId(Point object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _pointGetLinks(Point object) {
  return [object.pointToMovil];
}

void _pointAttach(IsarCollection<dynamic> col, Id id, Point object) {
  object.id = id;
  object.pointToMovil
      .attach(col, col.isar.collection<Movil>(), r'pointToMovil', id);
}

extension PointQueryWhereSort on QueryBuilder<Point, Point, QWhere> {
  QueryBuilder<Point, Point, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PointQueryWhere on QueryBuilder<Point, Point, QWhereClause> {
  QueryBuilder<Point, Point, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Point, Point, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Point, Point, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Point, Point, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Point, Point, QAfterWhereClause> idBetween(
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

extension PointQueryFilter on QueryBuilder<Point, Point, QFilterCondition> {
  QueryBuilder<Point, Point, QAfterFilterCondition> dateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'date',
      ));
    });
  }

  QueryBuilder<Point, Point, QAfterFilterCondition> dateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'date',
      ));
    });
  }

  QueryBuilder<Point, Point, QAfterFilterCondition> dateEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<Point, Point, QAfterFilterCondition> dateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<Point, Point, QAfterFilterCondition> dateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<Point, Point, QAfterFilterCondition> dateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Point, Point, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Point, Point, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Point, Point, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Point, Point, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Point, Point, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Point, Point, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Point, Point, QAfterFilterCondition> tariffEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tariff',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Point, Point, QAfterFilterCondition> tariffGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tariff',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Point, Point, QAfterFilterCondition> tariffLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tariff',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Point, Point, QAfterFilterCondition> tariffBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tariff',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension PointQueryObject on QueryBuilder<Point, Point, QFilterCondition> {}

extension PointQueryLinks on QueryBuilder<Point, Point, QFilterCondition> {
  QueryBuilder<Point, Point, QAfterFilterCondition> pointToMovil(
      FilterQuery<Movil> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'pointToMovil');
    });
  }

  QueryBuilder<Point, Point, QAfterFilterCondition> pointToMovilLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pointToMovil', length, true, length, true);
    });
  }

  QueryBuilder<Point, Point, QAfterFilterCondition> pointToMovilIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pointToMovil', 0, true, 0, true);
    });
  }

  QueryBuilder<Point, Point, QAfterFilterCondition> pointToMovilIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pointToMovil', 0, false, 999999, true);
    });
  }

  QueryBuilder<Point, Point, QAfterFilterCondition> pointToMovilLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pointToMovil', 0, true, length, include);
    });
  }

  QueryBuilder<Point, Point, QAfterFilterCondition>
      pointToMovilLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pointToMovil', length, include, 999999, true);
    });
  }

  QueryBuilder<Point, Point, QAfterFilterCondition> pointToMovilLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'pointToMovil', lower, includeLower, upper, includeUpper);
    });
  }
}

extension PointQuerySortBy on QueryBuilder<Point, Point, QSortBy> {
  QueryBuilder<Point, Point, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<Point, Point, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<Point, Point, QAfterSortBy> sortByTariff() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tariff', Sort.asc);
    });
  }

  QueryBuilder<Point, Point, QAfterSortBy> sortByTariffDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tariff', Sort.desc);
    });
  }
}

extension PointQuerySortThenBy on QueryBuilder<Point, Point, QSortThenBy> {
  QueryBuilder<Point, Point, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<Point, Point, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<Point, Point, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Point, Point, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Point, Point, QAfterSortBy> thenByTariff() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tariff', Sort.asc);
    });
  }

  QueryBuilder<Point, Point, QAfterSortBy> thenByTariffDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tariff', Sort.desc);
    });
  }
}

extension PointQueryWhereDistinct on QueryBuilder<Point, Point, QDistinct> {
  QueryBuilder<Point, Point, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<Point, Point, QDistinct> distinctByTariff() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tariff');
    });
  }
}

extension PointQueryProperty on QueryBuilder<Point, Point, QQueryProperty> {
  QueryBuilder<Point, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Point, DateTime?, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<Point, double, QQueryOperations> tariffProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tariff');
    });
  }
}
