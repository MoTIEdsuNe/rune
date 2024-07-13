//! `SeaORM` Entity. Generated by sea-orm-codegen 0.12.15

use async_graphql::SimpleObject;
use sea_orm::entity::prelude::*;

#[derive(Clone, Debug, PartialEq, DeriveEntityModel, SimpleObject)]
#[sea_orm(table_name = "media_analysis")]
pub struct Model {
    #[sea_orm(primary_key)]
    pub id: i32,
    pub file_id: i32,
    pub sample_rate: i32,
    #[sea_orm(column_type = "Double")]
    pub duration: f64,
    #[sea_orm(column_type = "Double", nullable)]
    pub spectral_centroid: Option<f64>,
    #[sea_orm(column_type = "Double", nullable)]
    pub spectral_flatness: Option<f64>,
    #[sea_orm(column_type = "Double", nullable)]
    pub spectral_slope: Option<f64>,
    #[sea_orm(column_type = "Double", nullable)]
    pub spectral_rolloff: Option<f64>,
    #[sea_orm(column_type = "Double", nullable)]
    pub spectral_spread: Option<f64>,
    #[sea_orm(column_type = "Double", nullable)]
    pub spectral_skewness: Option<f64>,
    #[sea_orm(column_type = "Double", nullable)]
    pub spectral_kurtosis: Option<f64>,
    #[sea_orm(column_type = "Double", nullable)]
    pub chroma0: Option<f64>,
    #[sea_orm(column_type = "Double", nullable)]
    pub chroma1: Option<f64>,
    #[sea_orm(column_type = "Double", nullable)]
    pub chroma2: Option<f64>,
    #[sea_orm(column_type = "Double", nullable)]
    pub chroma3: Option<f64>,
    #[sea_orm(column_type = "Double", nullable)]
    pub chroma4: Option<f64>,
    #[sea_orm(column_type = "Double", nullable)]
    pub chroma5: Option<f64>,
    #[sea_orm(column_type = "Double", nullable)]
    pub chroma6: Option<f64>,
    #[sea_orm(column_type = "Double", nullable)]
    pub chroma7: Option<f64>,
    #[sea_orm(column_type = "Double", nullable)]
    pub chroma8: Option<f64>,
    #[sea_orm(column_type = "Double", nullable)]
    pub chroma9: Option<f64>,
    #[sea_orm(column_type = "Double", nullable)]
    pub chroma10: Option<f64>,
    #[sea_orm(column_type = "Double", nullable)]
    pub chroma11: Option<f64>,
}

#[derive(Copy, Clone, Debug, EnumIter, DeriveRelation)]
pub enum Relation {
    #[sea_orm(
        belongs_to = "super::media_files::Entity",
        from = "Column::FileId",
        to = "super::media_files::Column::Id",
        on_update = "NoAction",
        on_delete = "NoAction"
    )]
    MediaFiles,
}

impl Related<super::media_files::Entity> for Entity {
    fn to() -> RelationDef {
        Relation::MediaFiles.def()
    }
}

impl ActiveModelBehavior for ActiveModel {}
