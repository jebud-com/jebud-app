// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'period_expense_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetPeriodExpenseModelCollection on Isar {
  IsarCollection<PeriodExpenseModel> get periodExpenseModels =>
      this.collection();
}

const PeriodExpenseModelSchema = CollectionSchema(
  name: r'PeriodExpenseModel',
  id: 8490649999959620780,
  properties: {
    r'amount': PropertySchema(
      id: 0,
      name: r'amount',
      type: IsarType.double,
    ),
    r'applyUntil': PropertySchema(
      id: 1,
      name: r'applyUntil',
      type: IsarType.dateTime,
    ),
    r'description': PropertySchema(
      id: 2,
      name: r'description',
      type: IsarType.string,
    ),
    r'startingFrom': PropertySchema(
      id: 3,
      name: r'startingFrom',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _periodExpenseModelEstimateSize,
  serialize: _periodExpenseModelSerialize,
  deserialize: _periodExpenseModelDeserialize,
  deserializeProp: _periodExpenseModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _periodExpenseModelGetId,
  getLinks: _periodExpenseModelGetLinks,
  attach: _periodExpenseModelAttach,
  version: '3.0.5',
);

int _periodExpenseModelEstimateSize(
  PeriodExpenseModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.description.length * 3;
  return bytesCount;
}

void _periodExpenseModelSerialize(
  PeriodExpenseModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.amount);
  writer.writeDateTime(offsets[1], object.applyUntil);
  writer.writeString(offsets[2], object.description);
  writer.writeDateTime(offsets[3], object.startingFrom);
}

PeriodExpenseModel _periodExpenseModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PeriodExpenseModel(
    amount: reader.readDouble(offsets[0]),
    applyUntil: reader.readDateTime(offsets[1]),
    description: reader.readString(offsets[2]),
    startingFrom: reader.readDateTime(offsets[3]),
  );
  object.id = id;
  return object;
}

P _periodExpenseModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _periodExpenseModelGetId(PeriodExpenseModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _periodExpenseModelGetLinks(
    PeriodExpenseModel object) {
  return [];
}

void _periodExpenseModelAttach(
    IsarCollection<dynamic> col, Id id, PeriodExpenseModel object) {
  object.id = id;
}

extension PeriodExpenseModelQueryWhereSort
    on QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QWhere> {
  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PeriodExpenseModelQueryWhere
    on QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QWhereClause> {
  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterWhereClause>
      idBetween(
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

extension PeriodExpenseModelQueryFilter
    on QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QFilterCondition> {
  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterFilterCondition>
      amountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterFilterCondition>
      amountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterFilterCondition>
      amountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterFilterCondition>
      amountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterFilterCondition>
      applyUntilEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'applyUntil',
        value: value,
      ));
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterFilterCondition>
      applyUntilGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'applyUntil',
        value: value,
      ));
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterFilterCondition>
      applyUntilLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'applyUntil',
        value: value,
      ));
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterFilterCondition>
      applyUntilBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'applyUntil',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterFilterCondition>
      descriptionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterFilterCondition>
      descriptionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterFilterCondition>
      descriptionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterFilterCondition>
      descriptionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterFilterCondition>
      descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterFilterCondition>
      descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterFilterCondition>
      descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterFilterCondition>
      descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterFilterCondition>
      descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterFilterCondition>
      descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
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

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterFilterCondition>
      idLessThan(
    Id value, {
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

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
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

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterFilterCondition>
      startingFromEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startingFrom',
        value: value,
      ));
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterFilterCondition>
      startingFromGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startingFrom',
        value: value,
      ));
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterFilterCondition>
      startingFromLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startingFrom',
        value: value,
      ));
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterFilterCondition>
      startingFromBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startingFrom',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PeriodExpenseModelQueryObject
    on QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QFilterCondition> {}

extension PeriodExpenseModelQueryLinks
    on QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QFilterCondition> {}

extension PeriodExpenseModelQuerySortBy
    on QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QSortBy> {
  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterSortBy>
      sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterSortBy>
      sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterSortBy>
      sortByApplyUntil() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'applyUntil', Sort.asc);
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterSortBy>
      sortByApplyUntilDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'applyUntil', Sort.desc);
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterSortBy>
      sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterSortBy>
      sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterSortBy>
      sortByStartingFrom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startingFrom', Sort.asc);
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterSortBy>
      sortByStartingFromDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startingFrom', Sort.desc);
    });
  }
}

extension PeriodExpenseModelQuerySortThenBy
    on QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QSortThenBy> {
  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterSortBy>
      thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterSortBy>
      thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterSortBy>
      thenByApplyUntil() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'applyUntil', Sort.asc);
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterSortBy>
      thenByApplyUntilDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'applyUntil', Sort.desc);
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterSortBy>
      thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterSortBy>
      thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterSortBy>
      thenByStartingFrom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startingFrom', Sort.asc);
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QAfterSortBy>
      thenByStartingFromDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startingFrom', Sort.desc);
    });
  }
}

extension PeriodExpenseModelQueryWhereDistinct
    on QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QDistinct> {
  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QDistinct>
      distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QDistinct>
      distinctByApplyUntil() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'applyUntil');
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QDistinct>
      distinctByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QDistinct>
      distinctByStartingFrom() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startingFrom');
    });
  }
}

extension PeriodExpenseModelQueryProperty
    on QueryBuilder<PeriodExpenseModel, PeriodExpenseModel, QQueryProperty> {
  QueryBuilder<PeriodExpenseModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PeriodExpenseModel, double, QQueryOperations> amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<PeriodExpenseModel, DateTime, QQueryOperations>
      applyUntilProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'applyUntil');
    });
  }

  QueryBuilder<PeriodExpenseModel, String, QQueryOperations>
      descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<PeriodExpenseModel, DateTime, QQueryOperations>
      startingFromProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startingFrom');
    });
  }
}
