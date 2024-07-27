use lofty::file::TaggedFileExt;

use crate::crc::media_crc32;

pub struct CoverArt {
    pub crc: String,
    pub data: Vec<u8>,
}

pub fn extract_cover_art_binary(file_path: &str) -> Option<CoverArt> {
    let tagged_file = lofty::read_from_path(file_path).ok()?;

    let tag = tagged_file
        .primary_tag()
        .or_else(|| tagged_file.first_tag())?;

    let pictures = tag.pictures();
    if pictures.is_empty() {
        return None;
    }

    let picture = &pictures[0];
    let cover_data = picture.data().to_vec();

    // Calculate the CRC
    let crc = media_crc32(&cover_data, 0, 0, cover_data.len());
    let crc_string = format!("{:08x}", crc);

    Some(CoverArt {
        crc: crc_string,
        data: cover_data,
    })
}
