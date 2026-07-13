{
  "AGENDA des GV" = [
    {
      Agenda = {
        icon = "mdi-calendar-month";
        href = "https://www.lesgrandsvoisins.com/fr/";
        description = "Calendrier ";
        widget = {
          type = "calendar";
          firstDayInWeek = "monday";
          view = "agenda";
          maxEvents = 25;
          showTime = true;
          timezone = "Europe/Paris";
          integrations = [
            {
              type = "ical";
              url = "https://pcal.gv.je/public/public";
              name = "Agenda Les Grands Voisins par Radicale";
              params = {showName = false;};
            }
            {
              type = "ical";
              url = "https://openagenda.com/agendas/17490527/events.v2.ics?relative%5B0%5D=current&relative%5B1%5D=upcoming&displayExportModal=embed";
              name = "OpenAgenda LesGrandsVoisins.com";
            }
          ];
        };
      };
    }
  ];
}
