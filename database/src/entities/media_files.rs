//! `SeaORM` Entity. Generated by sea-orm-codegen 0.12.15

use async_graphql::*;
use sea_orm::entity::prelude::*;

#[derive(Clone, Debug, PartialEq, DeriveEntityModel, Eq, SimpleObject)]
#[sea_orm(table_name = "media_files")]
pub struct Model {
    #[sea_orm(primary_key)]
    pub id: i32,
    pub file_name: String,
    pub directory: String,
    pub extension: String,
    pub file_hash: String,
    pub last_modified: String,
}

#[derive(Copy, Clone, Debug, EnumIter, DeriveRelation)]
pub enum Relation {
    #[sea_orm(has_many = "super::media_analysis::Entity")]
    MediaAnalysis,
    #[sea_orm(has_many = "super::media_metadata::Entity")]
    MediaMetadata,
    #[sea_orm(has_many = "super::playlist_items::Entity")]
    PlaylistItems,
    #[sea_orm(has_many = "super::user_logs::Entity")]
    UserLogs,
}

impl Related<super::media_analysis::Entity> for Entity {
    fn to() -> RelationDef {
        Relation::MediaAnalysis.def()
    }
}

impl Related<super::media_metadata::Entity> for Entity {
    fn to() -> RelationDef {
        Relation::MediaMetadata.def()
    }
}

impl Related<super::playlist_items::Entity> for Entity {
    fn to() -> RelationDef {
        Relation::PlaylistItems.def()
    }
}

impl Related<super::user_logs::Entity> for Entity {
    fn to() -> RelationDef {
        Relation::UserLogs.def()
    }
}

impl ActiveModelBehavior for ActiveModel {}
