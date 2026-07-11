// What it does: every component size (button height, avatar size, 
// etc.) used anywhere in the app lives here. Instead of writing
//  SizedBox(height: 16) scattered everywhere with a mix of 16, 15
//  , 18 by accident, you write SizedBox(height: AppDimens.space16)
//   — guaranteed consistent.