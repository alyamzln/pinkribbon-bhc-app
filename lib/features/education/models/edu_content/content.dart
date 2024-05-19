import 'package:pinkribbonbhc/features/education/models/edu_content/item_model.dart';
import 'package:pinkribbonbhc/utils/constants/image_strings.dart';

class SymptomContent {
  final List<Item> _symptomContent = [
    Item(TImages.symptom1, 'DIMPLE',
        "If there's a dimple or ridge in your skin that is not caused by a seam or tight clothing, it can be due to the tumor pulling the skin inward. A dimple can be more easily seen when lifting your arms up above your head to see if the whole breast skin moves with you as you raise and lower your arms. "),
    Item(TImages.symptom2, 'ENLARGED VEIN',
        "Veins can show up for circulatory issues, breastfeeding or weight changes, HOWEVER if a vein becomes enlarged with other signs such as redness or swelling, it may be a sign of breast cancer."),
    Item(TImages.symptom3, 'HARD LUMPS OR BUMPS',
        "This is the MOST COMMON sign of breast cancer. Lumps in the breast are very common and may be a sign of natural breast tissue. They may also be something like a cyst or a benign lump. If you have hard lumps that are new, growing or don't move very well, be sure to reach out to your doctor for further assessment of these lumps."),
    Item(TImages.symptom4, 'ITCHING',
        "Itching can commonly occur due to skin changes, dryness, or irritation from lotions or body washes. However, if it persists despite changes in products or skincare routines, it could potentially indicate a sign of breast cancer."),
    Item(TImages.symptom5, 'NIPPLE SCAB OR CRUST',
        "If you notice a scab-like area that is white or red over the nipple area that's not related to anything like breastfeeding, be sure to reach out to your doctor."),
    Item(TImages.symptom6, "PEAU D'ORANGE",
        "Also known as Peau d'orange, when the skin of your breast appears dimpled, resembling the texture of an orange peel, it can be a sign of breast cancer. This dimpling is caused by swelling in the breast, which makes the hair follicles appear dimpled on the skin."),
    Item(TImages.symptom7, 'RED, HOT AND SWOLLEN',
        "This is a common sign of infection such as in mastitis from breastfeeding, or from other skin changes such as eczhema. However, breast cancer can stop the flow of lymphatic fluid which may change the color of the breast. If you have any signs of infection or unknown reasons for this, be sure to talk to your doctor."),
    Item(TImages.symptom8, 'SHAPE OR SIZE CHANGES',
        "It's extremely common for women to have breasts of different sizes and shapes between the left and right sides. Fluctuations can occur due to factors like breastfeeding and menstruation. However, if changes in size or shape are unrelated to these factors, it's important to follow up with your doctor."),
    Item(TImages.symptom9, 'SORES',
        "Breast cancer can lead to tissue changes that manifest from the inside out, potentially causing sores or wounds on the breast. These sores may be accompanied by a palpable lump. If you experience a sore without a known cause, it could be a potential sign of breast cancer."),
    Item(TImages.symptom10, 'SUNKEN OR INVERTED NIPPLE',
        "While inverted nipples can be a normal variation for some individuals, a new occurrence of inverted nipples may indicate changes such as a tumor pulling the nipple inward, flattening it, or causing it to sink in."),
    Item(TImages.symptom11, 'THICKENED AREA',
        "Breast density can be a normal occurrence during menstruation or breastfeeding. However, if it persists or worsens without resolving, it could indicate a potential sign of breast cancer."),
    Item(TImages.symptom12, 'UNEXPECTED NIPPLE DISCHARGE',
        "Breast discharge is often associated with various factors such as developing breasts, infections, cysts, pregnancy, and breastfeeding. However, if none of these common causes are evident, it could be a potential sign of breast cancer."),
  ];

  // get item list
  List<Item> get symptomContent => _symptomContent;
}

class MammogramTips {
  final List<Item> _mammogramTips = [
    Item(TImages.calendarPeriod, 'Schedule On The Right Time',
        "Schedule the test for a time when your breasts are least likely to be tender. If you menstruate, that's usually during the week after your menstrual period."),
    Item(TImages.noDeodorant, "DON’T Apply These!",
        "Before your mammogram, avoid using deodorants, lotions, cosmetics, perfumes or powders on your breasts, chest, or underarms."),
    Item(TImages.takePill, "Take Pain Medication",
        "Consider taking pain medication (over-the-counter) about one hour before your appointment time."),
    Item(TImages.twoPiece, "Wear a Two-piece Outfit",
        "Opt for a two-piece outfit consisting of a shirt and pants, shorts, or a skirt to make it easier to undress only the upper body during the mammogram."),
    Item(TImages.comfortShoes, "Wear Comfortable Shoes",
        "Choose comfortable shoes to ensure ease of movement and comfort while walking to and from the mammography appointment."),
    Item(TImages.noNecklace, "Avoid Neck Jewelry and Long Earrings",
        "Leave necklaces, chains, and long earrings at home to avoid interference with the mammogram equipment and to ensure a smooth procedure without any discomfort or obstruction."),
    Item(TImages.talkDoctor, "Share Important Information",
        "Share important information with the mammogram technician during your appointment, such as:\n- Any breast changes or problems you are experiencing\n- If you have breast implants\n- If you have trouble standing or holding still (without a cane or walker)\n- If you are breastfeeding\n- If you are or think you might be pregnant"),
    Item(TImages.relax, "Relax!",
        "Try to relax! This important screening will take only a few minutes."),
  ];

  List<Item> get mammogramTips => _mammogramTips;
}

class MythsFacts {
  final List<Item> _mythsFacts = [
    Item(
        TImages.familyHistory,
        'Myth: Breast cancer only affects those with family history',
        "Fact: 9/10 people diagnosed with breast cancer have no known family history"),
    Item(TImages.foundLump, 'Myth: Finding a lump means you have breast cancer',
        "Fact: Not all breast lumps are cancerous. Many breast lumps are benign (non-cancerous) and can be caused by hormonal changes, cysts, or other factors."),
    Item(
        TImages.adultWoman,
        'Myth: Breast cancer only happens to middle-aged women',
        "Fact: Young women can also get breast cancer. While the risk increases with age, breast cancer can affect women of all ages."),
    Item(TImages.maleRibbon, 'Myth: Only women get breast cancer',
        "Fact: While breast cancer is more common in women, men can also develop breast cancer, although it is rare."),
    Item(TImages.cancerSurvival, 'Myth: Breast cancer is a death sentence',
        "Fact: If detected and treated early, there is a high survival rate for breast cancer. Early detection through regular screenings can significantly improve outcomes."),
    Item(
        TImages.smallBreasted,
        'Myth: Small-breasted women are not at risk for breast cancer',
        "Fact: Breast cancer can affect women of all breast sizes, and breast size does not determine a person's risk of developing breast cancer."),
  ];

  List<Item> get mythsFacts => _mythsFacts;
}
